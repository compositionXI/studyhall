class Recommendation < ActiveRecord::Base

  belongs_to :user
  belongs_to :school
  
  attr_accessible :conn_cda, :user_id, :school_id, :rank_cda
  
  def Recommendation.populate_rec_bar(current_user_id)
    rec = Recommendation.find_by_user_id(current_user_id)
    if(rec.nil?)
      return [41,51,61]
    end
    reclist = reclist.rank_cda.to_s
    if(reclist == "-1" || reclist.nil? || reclist.empty?)
      return [41,51,61]
    else
      reclist = reclist.split(',')
      reclist.pop
      reclist.collect{|i| i.to_i}
      if(reclist.length > 4)
        reclist = reclist[0,4]
      end
      return reclist
    end
  end
  
  def Recommendation.initial_spawn(current_user_id)
    return Recommendation.find_by_user_id(current_user_id).nil?
  end

  #call this when creating a new user; maybe also run it initially because of existing db users without a rec attached
  def Recommendation.populate_user(all_users_ids)
    all_users_ids.each do |current_user_id|
      cui = current_user_id.to_i
      if(Recommendation.initial_spawn(cui))
        rankings = ''
        #generates list for every single user, not restricted to school - limits to first 5000 users
        #TODO break down by school to ease calculation; problems arise if somebody changes school
        10000.times do |iter|
          #first element will always be zero
          if(iter == cui) 
            rankings += '20,'
          else 
            rankings += '0,'
          end
        end
        @new_rec = Recommendation.new(:user_id => cui, :school_id => User.find_by_id(cui).school.id, :conn_cda => rankings)
        @new_rec.save!
      end
    end
  end
  
  #this updates the connections between users
  def Recommendation.connect_new(user1id, users2id, inc)
    #fine connection array for core user
    user = Recommendation.find_by_user_id(user1id).conn_cda.split(',')
    users = []
    #generate connection array for each user sequentially
    tempusers = Recommendation.where(:user_id => users2id)
    tempusers.each do |tu|
      users << tu.conn_cda.split(',')
    end
    users2id.each do |u2|
      #users << Recommendation.find_by_user_id(u2.to_i).conn_cda.split(',')
    end
    iter = 0
    #for each connection array of the noncore users
    users.each do |u2|
      #update core user array
      user[users2id[iter].to_i] = user[users2id[iter].to_i].to_i + inc
      #update the noncore user array element
      u2[user1id] = u2[user1id].to_i + inc
      #increment
      iter += 1
      #ruby wants it??
      something = u2
    end
    #reset iterator
    iter = 0
    #for each of the noncore users, indexed here by id
    users2id.each do |u2|
      #make temporary comma delimited string of the ith users updated connections
      up_user = users[iter].join(',')
      #find this user and update the connection cda
      Recommendation.find_by_user_id(users2id[iter]).update_attributes(:conn_cda => up_user)
      #increment
      iter += 1
      #ruby wants it??
      use = u2
    end
    #find the core user and update with new comma delimited array
    Recommendation.find_by_user_id(user1id).update_attributes(:conn_cda => user.join(','))
    #set constant return
    return true
  end
  
  def Recommendation.norm_dot_product(l1, l2)
	  sum = 0.0
	  normer = 0.0
	  l1.zip(l2) do |a, b| 
	    sum+=a*b
	    normer+= a**2 + b**2
    end
	  return sum/(normer**(1/2))
  end
  
  def Recommendation.list_all
    schools = School.all
    schools.each do |school|
      Rails.logger.info("Logging #{school.name} now.")
      Recommendation.generate_ranked_list(school.id)
    end
  end
  
  #also BIGGGGG method - only run intermittently to update Indices for everybody in a particular school
  def Recommendation.generate_ranked_list(schoolID)
    #fetch the school recs and generate empty arrays
    school_collect = Recommendation.where(:school_id => schoolID)
    schoolMatrix = []
    userIDS = []
    user_recs = []
    
    #grab the connections string and move it into a few arrays
    school_collect.each do |rec|
      #split the cda
      userCDA = rec.conn_cda.split(',')
      #write string to int
      userCDA = userCDA.collect{|i| i.to_i}
      #throw it into bigger array
      schoolMatrix << userCDA
      #nx1 array
      userIDS << rec.user_id
    end
    
    #use this as an iterator for writing to the db
    userid = 0
    
    #through the school matrix once
    schoolMatrix.each do |uid1|
      user_recs_final = []
      recs_temp = []
      
      #through the school matrix twice - note this will always rank the user first in his own list, so this needs to be processed out later
      schoolMatrix.each do |uid2|
        #normalize the dot product and push it to the array of listings
        recs_temp << Recommendation.norm_dot_product(uid1, uid2)
      end
      
      rtl = recs_temp.length
      #iterate through for each member of the array, this will work since index only returns the last of the max
      rtl.times do
        #use rindex because the last added member with the best linkage (ie not time based but more recent links) probably better match
        max_index = recs_temp.rindex(recs_temp.max)
        user_recs_final << userIDS[max_index]
        #set this element to a negative number so that next iteration we find second largest and so forth
        recs_temp[max_index] = -1
      end
      
      #push comma delimited string of complete rankings based upon user id for each student at this school
      @temp_rec = Recommendation.find_by_user_id(userIDS[userid])
      user_recs_final += [-1]
      user_recs_final.shift
      user_recs_string = user_recs_final.join(',')
      @temp_rec.update_attributes(:rank_cda => user_recs_string)
      
      #increment the iterator
      userid += 1
      #ruby wants it??
      use = uid1
    end
    return true
  end
  
=begin  
  #called by svd method
  def Recommendation.school_matrix(schoolID)
    school_collect = Recommendation.where(:school_id => schoolID)
    schoolMatrix = []
    userIDS = []
    school_collect.each do |rec|
      userCDA = rec.conn_cda.split(',')
      userCDA = userCDA.collect{|i| i.to_i}
      schoolMatrix << userCDA
      userIDS << rec.user_id
    end
    return userIDS, Linalg::DMatrix.rows(schoolMatrix)
  end
  
  #BIGGGGG method - only run intermittently to update Indices
  def Recommendation.svd(schoolID)
  
    userIDS, conn_matrix = Recommendation.school_matrix(schoolID)
  
    #do the svd
    u,s,v = conn_matrix.singular_value_decomposition
    vt = v.transpose
    
    #reduce to 10 space to get n x 10 matrices and 10 singular values
    u10 = Linalg::DMatrix.join_columns[u.column(0),u.column(1),u.column(2),u.column(3),u.column(4),u.column(5),u.column(6),u.column(7),u.column(8),u.column(9)]
    vt10 = Linalg::DMatrix.join_columns[vt.column(0),vt.column(1),vt.column(2),vt.column(3),vt.column(4),vt.column(5),vt.column(6),vt.column(7),vt.column(8),v.column(9)]
    s10 = Linalg::DMatrix.join_columns[s.column(0).to_a.flatten[0,10],s.column(1).to_a.flatten[0,10],s.column(2).to_a.flatten[0,10],s.column(3).to_a.flatten[0,10],s.column(4).to_a.flatten[0,10],s.column(5).to_a.flatten[0,10],s.column(6).to_a.flatten[0,10],s.column(7).to_a.flatten[0,10],s.column(8).to_a.flatten[0,10],s.column(9).to_a.flatten[0,10]]
    
    #now put this into strings and write to db for each user
    j = 0
    
    userIDS.each do |id|
      @rec_user = Recommendation.find(:user_id => id)
      u10string = u10.row(j).join(',')
      vt10string = vt10.row(j).join(',')
      @rec_user.update_attributes(:u_svd10 => u10string, :vt_svd10 => vt10string)
      j++
    end
    
    # we also need to update the singular values for the school
    eig_string = ''
    
    s10.rows.each do |r|
      eig_string += r.join(',') + ';'
    end
    
    School.find(:id => schoolID).update_attributes(:s_svd10 => s10)
    
    return true
        
  end
=end
  
end
