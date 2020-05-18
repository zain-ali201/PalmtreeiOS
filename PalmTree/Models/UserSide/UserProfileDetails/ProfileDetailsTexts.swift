//
//  ProfileDetailsTexts.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsTexts {
    
    var cancelBtn : String!
    var changePass : ProfileDetailsChangePassword!
    var isNumberVerified : Bool!
    var isNumberVerifiedText : String!
    var isVerificationOn : Bool!
    var phoneDialog : ProfileDetailsPhoneDialogue!
    var profileEditTitle : String!
    var profileTitle : String!
    var saveBtn : String!
    var selectImage : String!
    var selectPic : ProfileDetailsSelectPic!
    var sendSmsDialog : ProfileDetailsSendSmsDialogue!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cancelBtn = dictionary["cancel_btn"] as? String
        if let changePassData = dictionary["change_pass"] as? [String:Any]{
            changePass = ProfileDetailsChangePassword(fromDictionary: changePassData)
        }
        isNumberVerified = dictionary["is_number_verified"] as? Bool
        isNumberVerifiedText = dictionary["is_number_verified_text"] as? String
        isVerificationOn = dictionary["is_verification_on"] as? Bool
        if let phoneDialogData = dictionary["phone_dialog"] as? [String:Any]{
            phoneDialog = ProfileDetailsPhoneDialogue(fromDictionary: phoneDialogData)
        }
        profileEditTitle = dictionary["profile_edit_title"] as? String
        profileTitle = dictionary["profile_title"] as? String
        saveBtn = dictionary["save_btn"] as? String
        selectImage = dictionary["select_image"] as? String
        if let selectPicData = dictionary["select_pic"] as? [String:Any]{
            selectPic = ProfileDetailsSelectPic(fromDictionary: selectPicData)
        }
        if let sendSmsDialogData = dictionary["send_sms_dialog"] as? [String:Any]{
            sendSmsDialog = ProfileDetailsSendSmsDialogue(fromDictionary: sendSmsDialogData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cancelBtn != nil{
            dictionary["cancel_btn"] = cancelBtn
        }
        if changePass != nil{
            dictionary["change_pass"] = changePass.toDictionary()
        }
        if isNumberVerified != nil{
            dictionary["is_number_verified"] = isNumberVerified
        }
        if isNumberVerifiedText != nil{
            dictionary["is_number_verified_text"] = isNumberVerifiedText
        }
        if isVerificationOn != nil{
            dictionary["is_verification_on"] = isVerificationOn
        }
        if phoneDialog != nil{
            dictionary["phone_dialog"] = phoneDialog.toDictionary()
        }
        if profileEditTitle != nil{
            dictionary["profile_edit_title"] = profileEditTitle
        }
        if profileTitle != nil{
            dictionary["profile_title"] = profileTitle
        }
        if saveBtn != nil{
            dictionary["save_btn"] = saveBtn
        }
        if selectImage != nil{
            dictionary["select_image"] = selectImage
        }
        if selectPic != nil{
            dictionary["select_pic"] = selectPic.toDictionary()
        }
        if sendSmsDialog != nil{
            dictionary["send_sms_dialog"] = sendSmsDialog.toDictionary()
        }
        return dictionary
    }
    
}
