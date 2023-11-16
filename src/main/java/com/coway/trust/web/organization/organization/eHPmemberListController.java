package com.coway.trust.web.organization.organization;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.eHPmemberListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import com.coway.trust.util.EgovFormBasedFileVo;
import com.ibm.icu.util.Calendar;
import com.coway.trust.biz.organization.organization.eHpMemberListApplication;


import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class eHPmemberListController {
  private static final Logger logger = LoggerFactory.getLogger(eHPmemberListController.class);

  @Resource(name = "eHPmemberListService")
  private eHPmemberListService eHPmemberListService;

  @Resource(name = "memberListService")
  private MemberListService memberListService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;


  @Autowired
  private eHpMemberListApplication eHpMemberListApplication;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Value("${pdf.password}")
  private String pdfPassword;


  @RequestMapping(value = "/eHpMemberList.do")
   public String eHpMemberList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

       //화면에 공통코드값....가져와........
       List<EgovMap> nationality = memberListService.nationality();
       params.put("groupCode",1);
       params.put("userTypeId", sessionVO.getUserTypeId());

       String type="";
       if (params.get("userTypeId" ) == "4" ) {
           type = memberListService.selectTypeGroupCode(params);
       } else {
           params.put("userTypeId", sessionVO.getUserTypeId());
       }

       logger.debug("type : {}", type);

       if ( params.get("userTypeId" ) == "4"  && type == "42") {
           params.put("userTypeId", "2");
       } else if ( params.get("userTypeId" ) == "4"  && type == "43") {
           params.put("userTypeId", "3");
       } else if ( params.get("userTypeId" ) == "4"  && type == "45") {
           params.put("userTypeId", "1");
       } else if ( params.get("userTypeId" ) == "4"  && type.equals("")){
           params.put("userTypeId", "");
       }

       List<EgovMap> memberType = commonService.selectCodeList(params);
       params.put("mstCdId",2);
       params.put("groupCode", 45);
       params.put("separator", " - ");
       List<EgovMap> race = commonService.getDetailCommonCodeList(params);
       List<EgovMap> status = eHPmemberListService.eHPselectStatus();
       List<EgovMap> userBranch = memberListService.selectUserBranch();
       List<EgovMap> SOBranch = commonService.selectBranchList(params);
       List<EgovMap> user = memberListService.selectUser();

       model.addAttribute("nationality", nationality);
       model.addAttribute("memberType", memberType);
       model.addAttribute("race", race);
       model.addAttribute("status", status);
       model.addAttribute("userBranch", userBranch);
       model.addAttribute("SOBranch", SOBranch);
       model.addAttribute("user", user);

       params.put("userId", sessionVO.getUserId());
       EgovMap userRole = memberListService.getUserRole(params);
       model.addAttribute("userRole", userRole.get("roleid"));

       if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){
           EgovMap getUserInfo = salesCommonService.getUserInfo(params);
           model.put("memType", getUserInfo.get("memType"));
           model.put("orgCode", getUserInfo.get("orgCode"));
           model.put("grpCode", getUserInfo.get("grpCode"));
           model.put("deptCode", getUserInfo.get("deptCode"));
           model.put("memCode", getUserInfo.get("memCode"));
           logger.info("memType ##### " + getUserInfo.get("memType"));
       }


       return "organization/organization/eHpMemberList";
   }

  @RequestMapping(value = "/selectEHPMemberListNewPop.do")
   public String selectEHPMemberListNewPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

       params.put("mstCdId",2);
       List<EgovMap> race = eHPmemberListService.getDetailCommonCodeList(params);
       logger.debug("eHP params : " + params);
       params.put("mstCdId",4);
       List<EgovMap> marrital = commonService.getDetailCommonCodeList(params);
       List<EgovMap> nationality = memberListService.nationality();
       params.put("groupCode","state");
       params.put("codevalue","1");
       params.put("country","Malaysia");
       List<EgovMap> state = commonService.selectAddrSelCode(params);
       params.put("mstCdId",5);
       List<EgovMap> educationLvl = commonService.getDetailCommonCodeList(params);
       params.put("mstCdId",3);
       List<EgovMap> language = commonService.getDetailCommonCodeList(params);
       List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
       params.put("groupCode", 45);
       params.put("separator", " - ");
       List<EgovMap> SOBranch = commonService.selectBranchList(params);

       List<EgovMap> mainDeptList = memberListService.getMainDeptList();
       params.put("groupCode", "");
       List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;

       params.put("mstCdId",377);
       List<EgovMap> Religion = commonService.getDetailCommonCodeList(params);

       String userName = sessionVO.getUserName();
       params.put("userName", userName);

       List<EgovMap> DeptCdList = memberListService.getDeptCdListList(params);

       List<EgovMap> list = memberListService.getSpouseInfoView(params);
       logger.debug("return_Values: " + list.toString());

       logger.debug("race : {} "+race);
       logger.debug("marrital : {} "+marrital);
       logger.debug("nationality : {} "+nationality);
       logger.debug("state : {} "+state);
       logger.debug("educationLvl : {} "+educationLvl);
       logger.debug("language : {} "+language);
       logger.debug("Religion : {} "+Religion);

       logger.debug("DeptCdList : {} "+DeptCdList);

       model.addAttribute("race", race);
       model.addAttribute("marrital", marrital);
       model.addAttribute("nationality", nationality);
       model.addAttribute("state", state);
       model.addAttribute("educationLvl", educationLvl);
       model.addAttribute("language", language);
       model.addAttribute("issuedBank", selectIssuedBank);
       model.addAttribute("mainDeptList", mainDeptList);
       model.addAttribute("subDeptList", subDeptList);
       model.addAttribute("Religion", Religion);
       model.addAttribute("DeptCdList", DeptCdList);
       model.addAttribute("SOBranch", SOBranch);

       model.addAttribute("userType", sessionVO.getUserTypeId());

       model.addAttribute("spouseInfoView", list);
       model.addAttribute("memType", params.get("memType"));
	   model.addAttribute("pdfPwd", pdfPassword);

       // 호출될 화면
       return "organization/organization/eHpMemberListNewPop";
   }

  @RequestMapping(value = "/eHpMemberListEditPop.do")
   public String eHpMemberListEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    logger.debug("eHpMemberListEditPop - params : {}", params);
       List<EgovMap> branch = memberListService.branch();

       params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
       EgovMap selectMemberListView = null;

         // NEED AMEND FOR EHP
           selectMemberListView = eHPmemberListService.selectEHPmemberListView(params);
           logger.debug("selectMemberListView :   " + selectMemberListView);
       //List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();

       EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
       List<EgovMap> mainDeptList = memberListService.getMainDeptList();
       params.put("mstCdId",377);
       List<EgovMap> Religion = commonService.getDetailCommonCodeList(params);

       if(selectMemberListView != null){
           params.put("groupCode", selectMemberListView.get("mainDept"));
       }
       else{
           params.put("groupCode", "");
       }
           List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;
       model.addAttribute("userRoleId", sessionVO.getRoleId());

       params.put("groupCode", 45);
       params.put("separator", " - ");
       List<EgovMap> SOBranch = commonService.selectBranchList(params);

       model.addAttribute("SOBranch", SOBranch);
       model.addAttribute("ApplicantConfirm", ApplicantConfirm);
       model.addAttribute("memberView", selectMemberListView);// 있어
       //model.addAttribute("issuedBank", selectIssuedBank); //있어
       model.addAttribute("mainDeptList", mainDeptList);
       model.addAttribute("subDeptList", subDeptList);
       model.addAttribute("memType", params.get("memType"));
       model.addAttribute("memId", params.get("MemberID"));
       model.addAttribute("branch", branch);
       model.addAttribute("Religion", Religion);
       model.addAttribute("atchFileGrpId", params.get("atchFileGrpId"));
       // 호출될 화면
       return "organization/organization/eHpMemberListEditPop";
   }

  /**
   * Call commission rule book management Page
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectEHPMemberListDetailPop.do")
  public String selectEHPMemberListDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

      logger.debug("selectEHPMemberListDetailPop - params : {}", params);

      params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));

      EgovMap selectMemberListView = null;

      if ( params.get("MemberType").equals("2803")) {
          selectMemberListView = eHPmemberListService.selectEHPMemberListView(params);
      }
      //EgovMap selectMemberListView = memberListService.selectMemberListView(params);
      List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
      EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
      EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
      logger.debug("PAExpired : {}", PAExpired);
      logger.debug("selectMemberListView : {}", selectMemberListView);
      logger.debug("issuedBank : {}", selectIssuedBank);
      logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
      model.addAttribute("PAExpired", PAExpired);
      model.addAttribute("ApplicantConfirm", ApplicantConfirm);
      model.addAttribute("memberView", selectMemberListView);
      model.addAttribute("issuedBank", selectIssuedBank);
      model.addAttribute("atchFileGrpId",params.get("atchFileGrpId"));

      // 호출될 화면
      return "organization/organization/eHpMemberListDetailPop";
  }

   @RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

       String err = "";
       String code = "";
       List<String> seqs = new ArrayList<>();

       try{
            Set set = request.getFileMap().entrySet();
            Iterator i = set.iterator();

            while(i.hasNext()) {
                Map.Entry me = (Map.Entry)i.next();
                String key = (String)me.getKey();
                seqs.add(key);
            }

       List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "organization" + File.separator + "eHP", AppConstants.UPLOAD_MIN_FILE_SIZE, true);

       logger.debug("list.size : {}", list.size());

       params.put(CommonConstants.USER_ID, sessionVO.getUserId());

       eHpMemberListApplication.insertEHPAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

       params.put("attachFiles", list);
       code = AppConstants.SUCCESS;
       }catch(ApplicationException e){
           err = e.getMessage();
           code = AppConstants.FAIL;
       }

       ReturnMessage message = new ReturnMessage();
       message.setCode(code);
       message.setData(params);
       message.setMessage(err);

       return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/selectAttachList.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> getAttachList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
       logger.debug("params {}", params);
       List<EgovMap> attachList = eHPmemberListService.getAttachList(params) ;

       return ResponseEntity.ok( attachList);
   }

   @RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

       logger.debug("params =====================================>>  " + params);
       String err = "";
       String code = "";
       List<String> seqs = new ArrayList<>();

       try{
            Set set = request.getFileMap().entrySet();
            Iterator i = set.iterator();

            while(i.hasNext()) {
                Map.Entry me = (Map.Entry)i.next();
                String key = (String)me.getKey();
                seqs.add(key);
            }

           List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "organization" + File.separator + "eHP", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
           logger.debug("list.size : {}", list.size());
           params.put(CommonConstants.USER_ID, sessionVO.getUserId());

           eHpMemberListApplication.updateEHPAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

           params.put("attachFiles", list);
           code = AppConstants.SUCCESS;
       }catch(ApplicationException e){
           err = e.getMessage();
           code = AppConstants.FAIL;
       }

       ReturnMessage message = new ReturnMessage();
       message.setCode(code);
       message.setData(params);
       message.setMessage(err);

       return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/eHpMemberListSearch", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> eHpMemberListSearch(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

       logger.debug("memTypeCom : {}", params.get("eHPmemTypeCom"));
       logger.debug("eHpMemberListSearch - params : " + params);


       logger.debug("memberLevel : {}", sessionVO.getMemberLevel());
       logger.debug("userName : {}", sessionVO.getUserName());

       params.put("memberLevel", sessionVO.getMemberLevel());
       params.put("userName", sessionVO.getUserName());

       List<EgovMap> memberList = null;

       if (sessionVO.getUserTypeId() == 1) {
           params.put("userId", sessionVO.getUserId());

           EgovMap item = new EgovMap();
           item = (EgovMap) memberListService.getOrgDtls(params);

           params.put("deptCodeHd", item.get("lastDeptCode"));
           params.put("grpCodeHd", item.get("lastGrpCode"));
           params.put("orgCodeHd", item.get("lastOrgCode"));

       }

       //String MemType = params.get("eHPmemTypeCom").toString();
       //if (MemType.equals("2803")) {
           memberList = eHPmemberListService.selectEHPApplicantList(params);
       //} else {
       //    memberList = eHPmemberListService.selectEHPMemberList(params);
       //}

       return ResponseEntity.ok(memberList);
   }

   /**
    * Search rule book management list
    *
    * @param request
    * @param model
    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/eHPmemberSave", method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> saveEHPMember(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO ) throws Exception  {

       Boolean success = false;

       logger.debug("eHPmemberSave - params : {}", params);

       String memCode = "";
       ReturnMessage message = new ReturnMessage();

       //Check whether member is rejoin or not
       Boolean isRejoinMem = Boolean.parseBoolean(params.get("isRejoinMem").toString());
       String rejoinMemId = params.get("memId").toString();

       	params.put("nric", params.get("eHPnric").toString());
       	List<EgovMap> memberInfo = memberListService.selectMemberInfo(params);
    	List<EgovMap> memberApprovalInfo = memberListService.selectMemberApprovalInfo(params);

    	//Check nric is new joiner or existing member
		if(memberInfo.size() > 0) {
    		// if member's rejoin Approval status = Approved
    		if (memberApprovalInfo.size() > 0) {
    			if(memberInfo.get(0).get("memId").toString().equals(memberApprovalInfo.get(0).get("memId").toString())){
    				if(!memberApprovalInfo.get(0).get("apprStus").toString().equals("5")){
    					message.setCode("99");
    					message.setMessage("This applicant had been registered.");
    					return ResponseEntity.ok(message);
    				}
    			} else {
    				message.setCode("99");
    				message.setMessage("This applicant had been registered.");
    				return ResponseEntity.ok(message);
    			}
    		} else {
    			message.setCode("99");
    			message.setMessage("This applicant is in " + memberInfo.get(0).get("name").toString() +" status.");
			    return ResponseEntity.ok(message);
    		}
		} else {
			 //New member - Check whether exist in ORG0003D
		      List<EgovMap> memberExist = eHPmemberListService.getMemberExistByNRIC(params);
		       if(memberExist.size() > 0){
		    	   if(memberExist.get(0).get("stusId").toString().equals("1") || memberExist.get(0).get("stusId").toString().equals("44")){
    		    	   message.setCode("99");
    		    	   message.setMessage("This applicant is under pending agreement.");
    				   return ResponseEntity.ok(message);
		    	   }
		       }
		}

       // To check email address uniqueness - LMS could only receive unique email address. Hui Ding, 2021-10-20
       if (params.get("eHPemail") != null && !isRejoinMem && (rejoinMemId.equals(null) || rejoinMemId.equals(""))){
    	   List<EgovMap> HpExist = eHPmemberListService.selectHpApplByEmail(params);
    	   if(HpExist.size() > 0){
    		   message.setCode("99");
    		   message.setMessage("Email has been used");
    		   return ResponseEntity.ok(message);
    	   }
       }

       memCode = eHPmemberListService.saveEHPMember(params, sessionVO );

       logger.debug("memCode : {}", memCode);



       if(memCode.equals("") && memCode.equals(null)){
           message.setMessage("fail saved");
       }else{
           message.setMessage("Complete to Create eHP Application Code : " + memCode
        		   + "<br><br>Kindly Proceed to complete eHP application within 7 days from application date to avoid auto cancel <br><br>Thank You");
       }

   		//If is rejoin member
		if(isRejoinMem && !(rejoinMemId.equals(null) || rejoinMemId.equals(""))){
			params.put("memId", params.get("memId").toString());
			memberListService.updateMemberStatus(params);
		}

       logger.debug("message : {}", message);

       System.out.println("msg   " + success);

       return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/eHPmemberUpdate", method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> updateMemberList(@RequestBody Map<String, Object> params, Model model,
           SessionVO sessionVO) throws Exception {

       Boolean success = false;
       String msg = "";

       int userId = sessionVO.getUserId();
       logger.debug("eHPmemberUpdate - params : {}", params);

       String memCode = "";
       String memId = "";
       String memberType = "";

       memCode = (String) params.get("eHPmemCode");
       memberType = (String) params.get("eHPmemberType");
       // doc 공통업데이트

       params.put("updUserId", userId);

       eHPmemberListService.eHPMemberUpdate(params);

       // 결과 만들기.
       ReturnMessage message = new ReturnMessage();
       if (memCode.equals("") && memCode.equals(null)) {
           message.setMessage("fail saved");
       } else {
           message.setMessage("Compelete to Edit eHP Application Code : " + memCode);
       }
       logger.debug("message : {}", message + memCode);

       System.out.println("msg   " + success + memCode);
       //
       return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/getEHPMemberListMemberView", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> getMemberListMemberView(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

       logger.debug("getEHPMemberListMemberView - params : {}", params.toString());

     List<EgovMap> list = null;

         list = eHPmemberListService.selectEHPmemberView(params);
               EgovMap map= list.get(0);
               map.put("isHp", "YES");

       logger.debug("getEHPMemberListMemberView - List : " + list);

       return ResponseEntity.ok(list);
   }


   @RequestMapping(value = "/selectCollectBranch.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> selectCollectBranch(@RequestParam Map<String, Object> params) {

       List<EgovMap> eHPcollectionBrnch = eHPmemberListService.selectCollectBranch();
       return ResponseEntity.ok(eHPcollectionBrnch);
   }

   @RequestMapping(value = "/eHpMemberUpdateStatusPop.do")
   public String eHpMemberUpdateStatusPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

     logger.debug("param111==== : " + params.toString());

     params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
     EgovMap selectMemberListView = null;

       selectMemberListView = eHPmemberListService.selectEHPmemberListView(params);

       params.put("userId", sessionVO.getUserId());
       EgovMap userRole = memberListService.getUserRole(params);
       model.addAttribute("userRole", userRole.get("roleid"));
       model.addAttribute("memberView", selectMemberListView);

       if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){
           EgovMap getUserInfo = salesCommonService.getUserInfo(params);
           model.put("userMemType", getUserInfo.get("memType"));
           model.put("userOrgCode", getUserInfo.get("orgCode"));
           model.put("userGrpCode", getUserInfo.get("grpCode"));
           model.put("userDeptCode", getUserInfo.get("deptCode"));
           model.put("userMemCode", getUserInfo.get("memCode"));
           logger.info("memType ##### " + getUserInfo.get("memType"));
       }


       return "organization/organization/eHpMemberUpdateStatusPop";
   }

   @RequestMapping(value = "/eHPmemberStatusUpdate", method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> eHPmemberStatusUpdate(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO ) throws Exception  {

       Boolean success = false;

       logger.debug("eHPmemberStatusUpdate - params : {}", params);

       String memCode = params.get("eHPmemberCode").toString();
       String memberType = params.get("eHPmemType").toString();
       String eHPnric = params.get("eHPmemberNric").toString();
       params.put("eHPCreator",sessionVO.getUserId());
       params.put("eHPUpdator",sessionVO.getUserId());
       params.put("eHPmemberType", memberType);
       params.put("eHPnric", eHPnric);

       //String seq = params.get("eHPseq").toString();

       /*if(seq == "" || seq == null){
         eHPmemberListService.eHPmemberStatusInsert(params); // INSERT ORG0031D
       }else{
       eHPmemberListService.eHPmemberStatusUpdate(params); // UPDATE ORG0031D
       }*/

       eHPmemberListService.eHPmemberStatusInsert(params); // INSERT ORG0031D

       eHPmemberListService.eHPApplicantStatusUpdate(params); // UPDATE ORG0003D

       logger.debug("memCode : {}", memCode);

       ReturnMessage message = new ReturnMessage();

       if(memCode.equals("") && memCode.equals(null)){
           message.setMessage("Fail to update status for HP Applicant.");
       }else{
           message.setMessage("Update status successful for eHP Member Code : " +memCode);
       }
       logger.debug("message : {}", message);

       System.out.println("msg   " + success);

       return ResponseEntity.ok(message);
   }

    @RequestMapping(value = "/selectHPOrientation.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectHPOrientation(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
        logger.debug("eHP :: selectHPOrientation");

        Calendar cal = Calendar.getInstance();

        StringBuffer cDt = new StringBuffer();
        cDt.append(String.format("%04d", cal.get(cal.YEAR)));
        cDt.append(String.format("%02d", cal.get(cal.MONTH) + 1));
        cDt.append(String.format("%02d", cal.get(cal.DATE)));
        params.put("curDt", cDt.toString());

        // Original + 1 month
//        cal.add(Calendar.MONTH, 1);

        StringBuffer d2 = new StringBuffer();
        d2.append(String.format("%04d", cal.get(cal.YEAR)));
        d2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
        params.put("startDay", d2.toString());

        // Original + 2 months
        cal.add(Calendar.MONTH, 1);

        StringBuffer d3 = new StringBuffer();
        d3.append(String.format("%04d", cal.get(cal.YEAR)));
        d3.append(String.format("%02d", cal.get(cal.MONTH) + 1));
        params.put("endDay", d3.toString());

        List<EgovMap> orientation = eHPmemberListService.selectHPOrientation(params);
        return ResponseEntity.ok(orientation);
    }

    @RequestMapping(value = "/selecteHPFailRemark.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPreOrderFailStatus( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		List<EgovMap> result = eHPmemberListService.selecteHPFailRemark(params) ;

		return ResponseEntity.ok(result);
	}
}
