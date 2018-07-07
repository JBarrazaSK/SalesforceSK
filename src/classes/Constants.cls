/**
 * Description: Apex constants.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/11/2014
 **/
public without sharing class Constants {
    
    public static Map<String, Map<String, Id>> recordTypeMap {
        get {
            if(recordTypeMap == null) {
                recordTypeMap = new Map<String, Map<String, Id>>();
                for(RecordType recordType : [
                    SELECT Name, SObjectType
                    FROM RecordType
                ]) {
                    if(!recordTypeMap.containsKey(recordType.SObjectType)) {
                        recordTypeMap.put(recordType.SObjectType, new Map<String, String>());
                    }
                    recordTypeMap.get(recordType.SObjectType).put(recordType.Name, recordType.Id);
                }
            }
            return recordTypeMap;
        }
        set;
    }
    
    public static Map<String, Id> profileMap {
        get {
            if(profileMap == null) {
                profileMap = new Map<String, Id>();
                for(Profile profile : [
                    SELECT Name
                    FROM Profile
                ]) {
                    profileMap.put(profile.Name, profile.Id);
                }
            }
            return profileMap;
        }
        set;
    }
}