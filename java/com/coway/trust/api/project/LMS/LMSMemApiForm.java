package com.coway.trust.api.project.LMS;

import java.util.HashMap;
import java.util.Map;

import org.jsoup.helper.StringUtil;

import antlr.StringUtils;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : LMSMemApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2021. 08. 19.    MY-HLTANG   First creation
 * </pre>
 */
@ApiModel(value = "LMSMemApiForm", description = "LMSMemApiForm")
public class LMSMemApiForm {

	private String secretkey;
	private String username;
	private String email;
	private String firstname;
	private String lastname;
	private String idnumber;
	private String institution;
	private String department;
	private String phone1;
	private String city;
	private String country;
	private String profile_field_postcode;
	private String profile_field_address;
	private String profile_field_gender;
	private String profile_field_dob;
	private String profile_field_trainingbatch;
	private String profile_field_position;
	private String profile_field_branchcode;
	private String profile_field_branchname;
	private String profile_field_region;
	private String profile_field_organizationcode;
	private String profile_field_groupcode;
	private String profile_field_MemberStatus;
	private String profile_field_MemberType;
	private String profile_field_ManagerName;
	private String profile_field_ManagerID;
	private String profile_field_SeniorManagerName;
	private String profile_field_SeniorManagerID;
	private String profile_field_GeneralManagerName;
	private String profile_field_GeneralManagerID;
	private String profile_field_batch;
	private String profile_field_TrainingVenue;
	private String profile_field_TRNo;
	private String profile_field_Tshirtsize;
	private String profile_field_dateJoin;
	private String profile_field_dateResign;
	private String newusername;
	// Added for indicating sleeping HP
	private String userstatus;

	public String getUserstatus() {
		return userstatus;
	}
	public void setUserstatus(String userstatus) {
		this.userstatus = userstatus;
	}
	public String getSecretkey() {
		return secretkey;
	}
	public void setSecretkey(String secretkey) {
		this.secretkey = secretkey;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getFirstname() {
		return firstname;
	}
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	public String getLastname() {
		return lastname;
	}
	public void setLastname(String lastname) {
		this.lastname = lastname;
	}
	public String getIdnumber() {
		return idnumber;
	}
	public void setIdnumber(String idnumber) {
		this.idnumber = idnumber;
	}
	public String getInstitution() {
		return institution;
	}
	public void setInstitution(String institution) {
		this.institution = institution;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getPhone1() {
		return phone1;
	}
	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getProfile_field_postcode() {
		return profile_field_postcode;
	}
	public void setProfile_field_postcode(String profile_field_postcode) {
		this.profile_field_postcode = profile_field_postcode;
	}
	public String getProfile_field_address() {
		return profile_field_address;
	}
	public void setProfile_field_address(String profile_field_address) {
		this.profile_field_address = profile_field_address;
	}
	public String getProfile_field_gender() {
		return profile_field_gender;
	}
	public void setProfile_field_gender(String profile_field_gender) {
		this.profile_field_gender = profile_field_gender;
	}
	public String getProfile_field_dob() {
		return profile_field_dob;
	}
	public void setProfile_field_dob(String profile_field_dob) {
		this.profile_field_dob = profile_field_dob;
	}
	public String getProfile_field_trainingbatch() {
		return profile_field_trainingbatch;
	}
	public void setProfile_field_trainingbatch(String profile_field_trainingbatch) {
		this.profile_field_trainingbatch = profile_field_trainingbatch;
	}
	public String getProfile_field_position() {
		return profile_field_position;
	}
	public void setProfile_field_position(String profile_field_position) {
		this.profile_field_position = profile_field_position;
	}
	public String getProfile_field_branchcode() {
		return profile_field_branchcode;
	}
	public void setProfile_field_branchcode(String profile_field_branchcode) {
		this.profile_field_branchcode = profile_field_branchcode;
	}
	public String getProfile_field_branchname() {
		return profile_field_branchname;
	}
	public void setProfile_field_branchname(String profile_field_branchname) {
		this.profile_field_branchname = profile_field_branchname;
	}
	public String getProfile_field_region() {
		return profile_field_region;
	}
	public void setProfile_field_region(String profile_field_region) {
		this.profile_field_region = profile_field_region;
	}
	public String getProfile_field_organizationcode() {
		return profile_field_organizationcode;
	}
	public void setProfile_field_organizationcode(String profile_field_organizationcode) {
		this.profile_field_organizationcode = profile_field_organizationcode;
	}
	public String getProfile_field_groupcode() {
		return profile_field_groupcode;
	}
	public void setProfile_field_groupcode(String profile_field_groupcode) {
		this.profile_field_groupcode = profile_field_groupcode;
	}
	public String getProfile_field_MemberStatus() {
		return profile_field_MemberStatus;
	}
	public void setProfile_field_MemberStatus(String profile_field_MemberStatus) {
		this.profile_field_MemberStatus = profile_field_MemberStatus;
	}
	public String getProfile_field_MemberType() {
		return profile_field_MemberType;
	}
	public void setProfile_field_MemberType(String profile_field_MemberType) {
		this.profile_field_MemberType = profile_field_MemberType;
	}
	public String getProfile_field_ManagerName() {
		return profile_field_ManagerName;
	}
	public void setProfile_field_ManagerName(String profile_field_ManagerName) {
		this.profile_field_ManagerName = profile_field_ManagerName;
	}
	public String getProfile_field_ManagerID() {
		return profile_field_ManagerID;
	}
	public void setProfile_field_ManagerID(String profile_field_ManagerID) {
		this.profile_field_ManagerID = profile_field_ManagerID;
	}
	public String getProfile_field_SeniorManagerName() {
		return profile_field_SeniorManagerName;
	}
	public void setProfile_field_SeniorManagerName(String profile_field_SeniorManagerName) {
		this.profile_field_SeniorManagerName = profile_field_SeniorManagerName;
	}
	public String getProfile_field_SeniorManagerID() {
		return profile_field_SeniorManagerID;
	}
	public void setProfile_field_SeniorManagerID(String profile_field_SeniorManagerID) {
		this.profile_field_SeniorManagerID = profile_field_SeniorManagerID;
	}
	public String getProfile_field_GeneralManagerName() {
		return profile_field_GeneralManagerName;
	}
	public void setProfile_field_GeneralManagerName(String profile_field_GeneralManagerName) {
		this.profile_field_GeneralManagerName = profile_field_GeneralManagerName;
	}
	public String getProfile_field_GeneralManagerID() {
		return profile_field_GeneralManagerID;
	}
	public void setProfile_field_GeneralManagerID(String profile_field_GeneralManagerID) {
		this.profile_field_GeneralManagerID = profile_field_GeneralManagerID;
	}
	public String getProfile_field_batch() {
		return profile_field_batch;
	}
	public void setProfile_field_batch(String profile_field_batch) {
		this.profile_field_batch = profile_field_batch;
	}
	public String getProfile_field_TrainingVenue() {
		return profile_field_TrainingVenue;
	}
	public void setProfile_field_TrainingVenue(String profile_field_TrainingVenue) {
		this.profile_field_TrainingVenue = profile_field_TrainingVenue;
	}
	public String getProfile_field_TRNo() {
		return profile_field_TRNo;
	}
	public void setProfile_field_TRNo(String profile_field_TRNo) {
		this.profile_field_TRNo = profile_field_TRNo;
	}
	public String getProfile_field_Tshirtsize() {
		return profile_field_Tshirtsize;
	}
	public void setProfile_field_Tshirtsize(String profile_field_Tshirtsize) {
		this.profile_field_Tshirtsize = profile_field_Tshirtsize;
	}
	public String getProfile_field_dateJoin() {
		return profile_field_dateJoin;
	}
	public void setProfile_field_dateJoin(String profile_field_dateJoin) {
		this.profile_field_dateJoin = profile_field_dateJoin;
	}
	public String getProfile_field_dateResign() {
		return profile_field_dateResign;
	}
	public void setProfile_field_dateResign(String profile_field_dateResign) {
		this.profile_field_dateResign = profile_field_dateResign;
	}
	public String getNewusername() {
		return newusername;
	}
	public void setNewusername(String newusername) {
		this.newusername = newusername;
	}





}
