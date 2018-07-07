/*
    Copyright (c) ajay-gupta.com
    All rights reserved.
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
    3. The name of the author may not be used to endorse or promote products
       derived from this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/**
 * Author :     Ajay Gupta
 * ClassName :  uploadDataTosObject
 * Description : This class used to insert the data into salesforce.
 *               
 **/
public with sharing class uploadDataTosObject {
   
    List<Account> forInsert = new List<Account>();
    public Integer size {get;set;}
    String myString {get;set;}
    public Boolean status {get;set;}
    public String message {get;set;}
    
    public uploadDataTosObject(){
        myString= '';
        size = 0;
        status= false;
    }
     public PageReference parseData(){
        parseJSONString();
        if(forInsert.size()>0){
            try{
               
                size = forInsert.size();
                status = true;
                insert forInsert ;
                }catch(Exception e){
                    status = false;
                    message = e.getMessage();
            }
        }
        return Null;
    }
    
    public void parseJSONString() {
    String jsonStr = myString;
    forInsert = new List<Account>();
    JSONParser parser = JSON.createParser(jsonStr);
    while (parser.nextToken() != null) {
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    Account acc = (Account)parser.readValueAs(Account.class);
                    forInsert.add(acc);
//                    System.debug('Debug'+ acc.active__c);
                    String s = JSON.serialize(acc);
                    system.debug('Serialized invoice: ' + s);
                    parser.skipChildren();
                    }
                }
            }
        }
    } 
}