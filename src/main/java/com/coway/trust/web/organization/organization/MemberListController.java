package com.coway.trust.web.organization.organization;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.organization.organization.HPMeetingPointUploadVO;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.eHPmemberListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class MemberListController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "memberListService")
	private MemberListService memberListService;

	@Resource(name = "eHPmemberListService")
	private eHPmemberListService eHPmemberListService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "tagMgmtService")
	TagMgmtService tagMgmtService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  	@Resource(name="locationService")
  	private LocationService locationService;

  	@Autowired
    private LoginService loginService;

	@Autowired
    private LMSApiService lmsApiService;

	@Autowired
    private SessionHandler sessionHandler;

	@Autowired
    private AdaptorService adaptorService;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Autowired
    private CsvReadComponent csvReadComponent;

    //Added by keyi HP social media
	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberList.do")
	public String memberList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		////logger.debug("sessionVO  getUserTypeId  {} " , sessionVO.getUserTypeId());

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

		////logger.debug("type : {}", type);

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
		params.put("dtailDisabled",0);
		List<EgovMap> race = commonService.getDetailCommonCodeList(params);
		List<EgovMap> status = memberListService.selectStatus();

		List<EgovMap> userBranch = memberListService.selectUserBranch();

		List<EgovMap> user = memberListService.selectUser();
		/*logger.debug("-------------controller------------");
		logger.debug("nationality    " + nationality);
		logger.debug("memberType    " + memberType);
		logger.debug("race    " + race);
		logger.debug("status    " + status);
		logger.debug("userBranch    " + userBranch);
		logger.debug("user    " + user);*/
		model.addAttribute("nationality", nationality);
		model.addAttribute("memberType", memberType);
		model.addAttribute("race", race);
		model.addAttribute("status", status);
		model.addAttribute("userBranch", userBranch);
		model.addAttribute("user", user);

		params.put("userId", sessionVO.getUserId());
		EgovMap userRole = memberListService.getUserRole(params);
		//logger.debug("userRole     " + userRole);
		model.addAttribute("userRole", userRole.get("roleid"));

    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
		//if( sessionVO.getUserTypeId() == 1){
      EgovMap result =  salesCommonService.getUserInfo(params);

      model.put("orgCode", result.get("orgCode"));
      model.put("grpCode", result.get("grpCode"));
      model.put("deptCode", result.get("deptCode"));
      model.put("memCode", result.get("memCode"));
    }

		// 호출될 화면
		return "organization/organization/memberList";
	}

	/*By KV start - Position - This is for Position link for Position is list in selection*/
	@RequestMapping(value = "/positionList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>positionList (@RequestParam Map<String, Object> params, ModelMap model){
		return ResponseEntity.ok(memberListService.selectPosition(params));
	}
	/*By KV end - Position - This is for Position link for Position is list in selection*/

	/*By KV start - ReplacementCT - selection in requestvacation*/
	@RequestMapping(value = "/selectReplaceCTList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReplaceCTList(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {
		   //logger.debug("groupCode : {}", params);
           params.put("brnch_id", params.get("brnch_id")  );
           params.put("mem_id",params.get("mem_id") );
           params.put("mem_code",params.get("mem_code") );
		   List<EgovMap> replacementCTList = memberListService.selectReplaceCTList(params);
		   return ResponseEntity.ok(replacementCTList);
	}
	/*By KV end - ReplacementCT - selection in requestvacation*/

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberListSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectmemberListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO,
			@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

//		logger.debug("memTypeCom : {}", params.get("memTypeCom"));
//		logger.debug("code : {}", params.get("code"));
//		logger.debug("name : {}", params.get("name"));
//		logger.debug("icNum : {}", params.get("icNum"));
//		logger.debug("birth : {}", params.get("birth"));
//		logger.debug("nation : {}", params.get("nation"));
//		logger.debug("race : {}", params.get("race"));
//		logger.debug("status : {}", params.get("status"));

		// By KV start - Do Search Button for Position Level
		//logger.debug("position : {}", params.get("position"));
		// By KV end - Do Search Button for Position Level

//		logger.debug("contact : {}", params.get("contact"));
//		logger.debug("sponsor : {}", params.get("sponsor"));
//		logger.debug("keyUser : {}", params.get("keyUser"));
//		logger.debug("keyBranch : {}", params.get("keyBranch"));
//		logger.debug("createDate : {}", params.get("createDate"));
//		logger.debug("endDate : {}", params.get("endDate"));

//		logger.debug("memberLevel : {}", sessionVO.getMemberLevel());
//		logger.debug("userName : {}", sessionVO.getUserName());

		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());

		List<EgovMap> memberList = null;

		params.put("sessionTypeID", sessionVO.getUserTypeId());
		if (sessionVO.getUserTypeId() == 1) {
			params.put("userId", sessionVO.getUserId());

			EgovMap item = new EgovMap();
			item = (EgovMap) memberListService.getOrgDtls(params);

			params.put("deptCodeHd", item.get("lastDeptCode"));
			params.put("grpCodeHd", item.get("lastGrpCode"));
			params.put("orgCodeHd", item.get("lastOrgCode"));

			/*else if (sessionVO.getMemberLevel() == 2) {
				params.put("grpCodeHd", item.get("lastGrpCode"));
				params.put("orgCodeHd", item.get("lastOrgCode"));
			} else if (sessionVO.getMemberLevel() == 1) {
				params.put("orgCodeHd", item.get("lastOrgCode"));
			}*/
		}

		String MemType = params.get("memTypeCom").toString();
		if (MemType.equals("2803")) {
			memberList = memberListService.selectHPApplicantList(params);
		} else {
			memberList = memberListService.selectMemberList(params);
		}

		return ResponseEntity.ok(memberList);
	}

	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberListDetailPop.do")
	public String selectMemberListDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

//		logger.debug("selCompensation in.............");
//		logger.debug("params: {}", params);

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));

		EgovMap selectMemberListView = null;

		if ( params.get("MemberType").equals("2803")) {
			selectMemberListView = memberListService.selectHPMemberListView(params);
		}else {
			selectMemberListView = memberListService.selectMemberListView(params);
		}

		//EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
//		logger.debug("PAExpired : {}", PAExpired);
//		logger.debug("selectMemberListView111 : {}", selectMemberListView);
//		logger.debug("issuedBank : {}", selectIssuedBank);
//		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);

		// 호출될 화면
		return "organization/organization/memberListDetailPop";
	}

	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberListNewPop.do")
	public String selectMemberListNewPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		params.put("mstCdId",2);
		List<EgovMap> race = commonService.getDetailCommonCodeList(params);
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

		List<EgovMap> mainDeptList = memberListService.getMainDeptList();
		params.put("groupCode", "");
		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;

		params.put("mstCdId",377);
		List<EgovMap> Religion = commonService.getDetailCommonCodeList(params);

		String userName = sessionVO.getUserName();
		params.put("userName", userName);

		List<EgovMap> DeptCdList = memberListService.getDeptCdListList(params);

		List<EgovMap> list = memberListService.getSpouseInfoView(params);
//		logger.debug("return_Values: " + list.toString());
//
//		logger.debug("race : {} "+race);
//		logger.debug("marrital : {} "+marrital);
//		logger.debug("nationality : {} "+nationality);
//		logger.debug("state : {} "+state);
//		logger.debug("educationLvl : {} "+educationLvl);
//		logger.debug("language : {} "+language);
//		logger.debug("Religion : {} "+Religion);
//
//		logger.debug("DeptCdList : {} "+DeptCdList);

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

		model.addAttribute("userType", sessionVO.getUserTypeId());

		model.addAttribute("spouseInfoView", list);
		model.addAttribute("memType", params.get("memType"));

		// 호출될 화면
		return "organization/organization/memberListNewPop";
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDocSubmission", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocSubmission(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		//logger.debug("MemberType : {} "+params.get("MemberType"));

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		List<EgovMap> selectDocSubmission;

		if("2".equals(params.get("MemberType").toString().trim())){//type가 Coway Lady면 쿼리가 살짝다름.....
			selectDocSubmission = memberListService.selectDocSubmission2(params);
		}else{
			selectDocSubmission = memberListService.selectDocSubmission(params);
		}

		//logger.debug("selectDocSubmission : {}", selectDocSubmission);
		return ResponseEntity.ok(selectDocSubmission);
	}


	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPromote", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromote(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> selectPromote = memberListService.selectPromote(params);
		//logger.debug("selectPromote : {}", selectPromote);
		return ResponseEntity.ok(selectPromote);
	}


	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPaymentHistory", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPaymentHistory(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> selectPaymentHistory = memberListService.selectPaymentHistory(params);
		//logger.debug("selectPaymentHistory : {}", selectPaymentHistory);
		return ResponseEntity.ok(selectPaymentHistory);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRenewalHistory", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRenewalHistory(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> selectRenewalHistory = memberListService.selectRenewalHistory(params);
		//logger.debug("selectRenewalHistory : {}", selectRenewalHistory);
		return ResponseEntity.ok(selectRenewalHistory);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectArea", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectArea(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		params.put("groupCode","area");
		params.put("codevalue",params.get("codevalue"));
		List<EgovMap> area = commonService.selectAddrSelCode(params);
		//logger.debug("area : {}", area);
		return ResponseEntity.ok(area);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberSave", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMemberl(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
		Boolean success = false;
		String msg = "";
//		logger.debug("params : {}", params);
//		logger.debug("memberNm : {}", params.get("memberNm"));
//		logger.debug("memberType : {}", params.get("memberType"));
//		logger.debug("joinDate : {}", params.get("joinDate"));
//		logger.debug("gender : {}", params.get("gender"));
//		logger.debug("gender : {}", params.get("gender"));
//		logger.debug("update : {}", params.get("docType"));
//		logger.debug("myGridID : {}", params.get("params"));

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		//logger.debug("udtList : {}", updList);
		//logger.debug("formMap : {}", formMap);

		try {
    		String memCode = "";

    		// To check email address uniqueness - LMS could only receive unique email address. Hui Ding, 2021-10-20
	       if (formMap.get("email") != null){
	    	   List<EgovMap> TrExist = memberListService.selectTrApplByEmail(formMap);
	    	   if(TrExist.size() > 0){
	    		   message.setMessage("Email has been used");
	    		   return ResponseEntity.ok(message);
	    	   }
	       }

    		memCode = memberListService.saveMember(formMap, updList, sessionVO);
    		int userId = sessionVO.getUserId();
    		String memberType =String.valueOf(formMap.get("memberType"));
    		String trainType =String.valueOf(formMap.get("traineeType1"));

    		//logger.debug(trainType + "train1111");
    		//doc 넣기

    		memberListService.insertDocSub(updList, memCode, userId, memberType, trainType);

    		//logger.debug("memCode : {}", memCode);
    		// 결과 만들기.

    //        	message.setCode(AppConstants.SUCCESS);
    //        	message.setData(map);
           	if(memCode.equals("") && memCode.equals(null)){
           		message.setMessage("fail saved");
           	}else{
           		message.setMessage("Compelete to Create a Member Code : " +memCode);
           	}
           	//logger.debug("message : {}", message);

		} catch (Exception e){
			message.setCode(AppConstants.FAIL);
			message.setMessage(e.getMessage());
		}
    	return ResponseEntity.ok(message);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectHpDocSubmission", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHpDocSubmission(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		//logger.debug("memberType : {}"+params.get("memType")+"11111111111111"); // member new detail edit 다쓰인다
		//logger.debug("params : {}"+params);
		List<EgovMap> selectDocSubmission;

		params.put("memType" , params.get("memType").toString().trim() );
		//logger.debug("params : {}"+params);
		if("2".equals( params.get("memType").toString().trim() )|| "2".equals(String.valueOf(params.get("trainType")))){//type가 Coway Lady면 traniee 쿼리가 살짝다름.....
			selectDocSubmission = memberListService.selectCodyDocSubmission(params);
		}else if("5".equals( String.valueOf(params.get("memType")).trim() )){
			 params.put("memId" , String.valueOf(params.get("memberID")));
			 EgovMap getTrainType = memberListService.memberListService(params);
			if("2".equals(String.valueOf(getTrainType.get("train")))){
				selectDocSubmission = memberListService.selectCodyDocSubmission(params);
			}
			else{
				selectDocSubmission = memberListService.selectHpDocSubmission(params);
			}

		}else{
			selectDocSubmission = memberListService.selectHpDocSubmission(params);
		}

		//logger.debug("selectDocSubmission : {}", selectDocSubmission);
		return ResponseEntity.ok(selectDocSubmission);
	}


	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/requestTerminateResign.do")
	public String selectTerminateResign(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		//logger.debug("codeValue : {}", params.get("codeValue"));

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
//		logger.debug("PAExpired : {}", PAExpired);
//		logger.debug("selectMemberListView : {}", selectMemberListView);
//		logger.debug("issuedBank : {}", selectIssuedBank);
//		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("codeValue", params.get("codeValue"));
		// 호출될 화면
		return "organization/organization/memberListDetailPop";
	}

	/**
	 * Member - Request Terminate/Resign
	 * Member - Request Promote/Demote
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/terminateResignSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertTerminateResign(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		try {
    		if(sessionVO != null){
    			//logger.debug("params : {}", params);
    			//logger.debug("sessionVO : {}", sessionVO.getUserId());
    			boolean success = false;
    			if(params.get("codeValue").toString().equals("1")){
    	    		int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
    	    		params.put("MemberID", memberId);
    	    		resultValue = memberListService.insertTerminateResign(params,sessionVO);
    	    		message.setMessage(resultValue.get("message").toString());

    			}else{
    				int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
    	    		params.put("memberId", memberId);
    	    		resultValue = memberListService.insertTerminateResign(params,sessionVO);
    	    		message.setMessage(resultValue.get("message").toString());
    			}
    		}

		} catch (Exception e){
			message.setCode(AppConstants.FAIL);
			message.setMessage(e.getMessage());
		}

		return ResponseEntity.ok(message);
	}

	/**
	 * Request Vacation Pop open List
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/requestVacationPop.do")
	public String selectRequestVacation(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		List<EgovMap> vact_type_id = commonService.getDetailCommonCodeList(params);
		/*EgovMap PAExpired = memberListService.selectCodyPAExpired(params);*/
		/*logger.debug("PAExpired : {}", PAExpired);*/
//		logger.debug("selectMemberListView : {}", selectMemberListView);
//		logger.debug("issuedBank : {}", selectIssuedBank);
//		logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
//		logger.debug("vact_type_id    " + vact_type_id);
		/*model.addAttribute("PAExpired", PAExpired);*/
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("codeValue", params.get("codeValue"));
		/* By Goo - get type of leave */
		model.addAttribute("vact_type_id", vact_type_id);
		return "organization/organization/requestVacationPop";
	}

	/**
	 * Save Request Vacation function
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/requestVacationSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertRequestVacation(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			//logger.debug("params : {}", params);
			//logger.debug("sessionVO : {}", sessionVO.getUserId());
			boolean success = false;

	    		int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
	    		params.put("MemberID", memberId);
	    		resultValue = memberListService.insertRequestVacation(params,sessionVO);
	    		message.setMessage(resultValue.get("message").toString());

		}
		return ResponseEntity.ok(message);
	}


	/**
	 * Request Trainee To Member Pop open List
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/confirmMemRegisPop.do")
	public String selectRequestTraineeToMem(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		/*EgovMap PAExpired = memberListService.selectCodyPAExpired(params);*/
		/*logger.debug("PAExpired : {}", PAExpired);*/
		//logger.debug("selectMemberListView : {}", selectMemberListView);
		//logger.debug("issuedBank : {}", selectIssuedBank);
		//logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		/*logger.debug("vact_type_id    " + vact_type_id);*/
		/*model.addAttribute("PAExpired", PAExpired);*/
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);
		model.addAttribute("issuedBank", selectIssuedBank);
		model.addAttribute("codeValue", params.get("codeValue"));
		return "organization/organization/confirmMemRegisPop";
	}

	/**
	 * Save Trainee To Member function - no yet done
	 * By KV
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*
	@RequestMapping(value = "/confirmMemRegisSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertRequestVacation(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			logger.debug("params : {}", params);
			logger.debug("sessionVO : {}", sessionVO.getUserId());
			boolean success = false;

	    		int memberId = params.get("requestMemberId") != null ? Integer.parseInt(params.get("requestMemberId").toString()) : 0;
	    		params.put("MemberID", memberId);
	    		resultValue = memberListService.insertRequestVacation(params,sessionVO);
	    		message.setMessage(resultValue.get("message").toString());

		}
		return ResponseEntity.ok(message);
	}
	*/






	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSuperiorTeam", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSuperiorTeam(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		params.put("memberLvl", params.get("groupCode[memberLvl]"));
		params.put("memberType", params.get("groupCode[memberType]"));
		params.put("memberID", params.get("groupCode[memberID]"));
		//logger.debug("params : {}", params);
		List<EgovMap> superiorTeam = memberListService.selectSuperiorTeam(params);
		//logger.debug("superiorTeam : {}", superiorTeam);
		return ResponseEntity.ok(superiorTeam);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDeptCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDeptCode(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		//logger.debug("params : {}", params);
		params.put("memberLvl", params.get("groupCode[memberLvl]"));
		params.put("flag", params.get("groupCode[flag]"));
		params.put("flag2", params.get("groupCode[flag2]"));
		params.put("branchVal", params.get("groupCode[branchVal]"));
		//logger.debug("params : {}", params);
		List<EgovMap> deptCode = memberListService.selectDeptCode(params);
		return ResponseEntity.ok(deptCode);
	}


	@RequestMapping(value = "/selectDeptCodeHp", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDeptCodeHp(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
/*		logger.debug("params : {}", params);
		params.put("memberLvl", params.get("groupCode[memberLvl]"));
		params.put("flag", params.get("groupCode[flag]"));
		params.put("branchVal", params.get("groupCode[branchVal]"));
		logger.debug("params : {}", params);*/
		//List<EgovMap> deptCode = memberListService.selectDeptCodeHp(params);

		String userName = sessionVO.getUserName();
		params.put("userName", userName);

		List<EgovMap> deptCode = memberListService.getDeptCdListList(params);
		return ResponseEntity.ok(deptCode);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCourse.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCourse(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		List<EgovMap> course = memberListService.selectCourse();
		return ResponseEntity.ok(course);
	}



	@RequestMapping(value = "/traineeUpdate.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>>  traineeUpdate(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();
		Map<String, Object> trInfo = new HashMap();

		//logger.debug("in...... traineeUpdate");
		//logger.debug("params : {}", params);

		try {
    		resultValue = memberListService.traineeUpdate(params,sessionVO);

    		if(null != resultValue){
    		    trInfo.put("memCode", (String)resultValue.get("memCode"));
    		    trInfo.put("telMobile", (String)resultValue.get("telMobile"));

    			//message.setMessage((String)resultValue.get("memCode"));
    		}
		} catch (Exception e){
			message.setCode(AppConstants.FAIL);
			message.setMessage(e.getMessage());
		}

		return ResponseEntity.ok(trInfo);
	}

	/**
	 * MemberList Edit Pop open
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberListEditPop.do")
	public String memberListEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> branch = memberListService.branch();
		//logger.debug("branchList : {}", branch);

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		//logger.debug("params123 : {}", params);
		EgovMap selectMemberListView = null;
		if(!params.get("memType").toString().equals("2803")){ //hp가 아닐때
			selectMemberListView = memberListService.selectMemberListView(params);
		}
		else{
			selectMemberListView = memberListService.selectOneHPMember(params);
		}
		//logger.debug("selectMemberListView : {}", selectMemberListView);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		//logger.debug("issuedBank : {}", selectIssuedBank);
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		//logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
		//logger.debug("PAExpired : {}", PAExpired);
		List<EgovMap> mainDeptList = memberListService.getMainDeptList();
		//logger.debug("mainDeptList : {}", mainDeptList);

		params.put("mstCdId",377);
		List<EgovMap> Religion = commonService.getDetailCommonCodeList(params);
		//logger.debug("Religion : {} "+Religion);

		if(selectMemberListView != null){
    		params.put("groupCode", selectMemberListView.get("mainDept"));
    		//logger.debug("params : {}", params);
    		//logger.debug("groupCode : {}", selectMemberListView.get("mainDept"));
		}
		else{
			params.put("groupCode", "");
		}
    		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;
    		//logger.debug("subDeptList : {}", subDeptList);

    	// 2020-02-04 - LaiKW - Added to block CDB Sales admin to self change branch
    	model.addAttribute("userRoleId", sessionVO.getRoleId());

		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);// 있어
		model.addAttribute("issuedBank", selectIssuedBank); //있어
		model.addAttribute("mainDeptList", mainDeptList);
		model.addAttribute("subDeptList", subDeptList);
		model.addAttribute("memType", params.get("memType"));
		model.addAttribute("memId", params.get("MemberID"));
		model.addAttribute("branch", branch);
		model.addAttribute("Religion", Religion);
		// 호출될 화면
		return "organization/organization/memberListEditPop";
	}

	@RequestMapping(value = "/memberValidDateEdit.do")
	public String memberValidDateEdit(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap memberValidDate = memberListService.selectMemberValidDate(params);
		//logger.debug("memValidDate : {}", memberValidDate);

		//model.addAttribute("memType", params.get("memType"));
		model.addAttribute("membercode", params.get("membercode"));
		model.addAttribute("memValidDate", memberValidDate);
		// 호출될 화면
		return "organization/organization/memberValidDateEdit";
	}

	@RequestMapping(value = "/getMemberListMemberView", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMemberListMemberView(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		//logger.debug("in  getMemberListMemberView.....");
		//logger.debug("params555 : {}", params.toString());
		List<EgovMap> list =null;
		if(!params.get("memType").toString().equals("2803") ){ // hp 가아닐떄
    		 list = memberListService.getMemberListView(params);
    		//logger.debug("return_Values: " + list.toString());
    		EgovMap map= list.get(0);
    		map.put("isHP", "NO");
		}
		else{// hp 일때
			 list = memberListService.getHpMemberView(params);
			 //logger.debug("return_Values: " + list.toString());
				EgovMap map= list.get(0);
				map.put("isHp", "YES");
		}

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/memberUpdate", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateMemberl(@RequestBody Map<String, Object> params, Model model,
            SessionVO sessionVO) throws Exception {

        // memberListService.saveDocSubmission(memberListVO,params, sessionVO);

        Boolean success = false;
        String msg = "";

        Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
        // Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
        List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
        List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
        List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

        //@AMEER INCOME TAX 2021-10-25
        formMap.put("incomeTaxNo", params.get("incomeTaxNo"));
        //logger.debug("@@incomeTaxNo : {}", params.get("incomeTaxNo"));


        int userId = sessionVO.getUserId();
        formMap.put("user_id", userId);
        //logger.debug("udtparam11111 : {}", params);
        //logger.debug("udtList : {}", updList);
        //logger.debug("formMap : {}", formMap);

        //logger.debug("memberNm : {}", formMap.get("memberNm"));
        //logger.debug("memberType : {}", formMap.get("memberType"));
        //logger.debug("joinDate : {}", formMap.get("joinDate"));
        //logger.debug("gender : {}", formMap.get("gender"));
        //logger.debug("update : {}", formMap.get("docType"));
        //logger.debug("myGridID : {}", formMap.get("params"));
        //logger.debug("hsptlz : {}", params.get("hsptlz"));

        // ADDED BY TOMMY 27/05/2020 FOR HOSPITALISATION CHECKBOX
        formMap.put("hsptlz",  params.get("hsptlz"));
        // LaiKW - Comment starts here
        formMap.put("memberType", formMap.get("memberTypeUpd"));
        formMap.put("MemberID", formMap.get("MemberIDUpd"));
        // LaiKW - Comment ends here

        String memCode = "";
        String memId = "";
        String memberType = "";
        boolean update = false;

        //logger.debug("formMap : {}", formMap);

        // update = memberListService.updateMember(formMap, updList,sessionVO);
        // memberListService.updateMemberBranch(formMap);
        // memberListService.updateMemberBranch2(formMap);

        // update

        /*
		memCode = (String) formMap.get("memCode");
        memId = (String) formMap.get("MemberID");
        memberType = (String) formMap.get("memberType");
        */

		// LaiKW - Comment starts here
        memCode = (String) formMap.get("memberCodeUpd");
        memId = (String) formMap.get("MemberIDUpd");
        memberType = (String) formMap.get("memberTypeUpd");
        // LaiKW - Comment ends here
        // doc 공통업데이트
        memberListService.updateDocSub(updList, memId, userId, memberType);

        int resultUpc1 = 0;
        int resultUpc2 = 0;
        int resultUpc3 = 0;
        int resultUpc4 = 0;
        int resultUpc5 = 0;
        int resultUpc6 = 0;

        int u1 = 0; // Branch update
        int u2 = 0; // Organization update
        int u3 = 0; // Member update
        int u4 = 0; // Applicant update
        int u5 = 0; // Training course
        int u6 = 0; // Service capacity
        int u7 = 0; // CD PA update

        // Not HP Applicant
        // hp가아닐때
        if (!formMap.get("memberType").toString().equals("2803")) {
            // LaiKW - Comment from here (New)
            if(formMap.containsKey("selectBranchUpd") || formMap.containsKey("convStaffFlgUpd")) {
                // Update SYS0047M - Branch/HR Code
                u1 = memberListService.memberListUpdate_SYS47(formMap);

                // Update ORG0005D - Branch ID
                if(formMap.containsKey("selectBranchUpd")) {
                    u2 = memberListService.memberListUpdate_ORG05(formMap);

                 // Added to update SYS0028M logistic warehouse branch as well by Hui Ding, 2021-01-07
                    locationService.updateBranchLoc(formMap);
                }
            }

            u3 = memberListService.memberListUpdate_ORG01(formMap);
            u4 = memberListService.memberListUpdate_ORG03(formMap);

            if(formMap.get("memberType").toString().equals("1") || formMap.get("memberType").toString().equals("2") ||
            		formMap.get("memberType").toString().equals("3") || formMap.get("memberType").toString().equals("5") ||
            		formMap.get("memberType").toString().equals("7") || formMap.get("memberType").toString().equals("2803")) {

            	//specify field update, just will need to update LMS system - HLTANG 20211028
            	if(formMap.containsKey("usernameUpd") || formMap.containsKey("memberNmUpd")
            			|| formMap.containsKey("emailUpd") || formMap.containsKey("mobileNoUpd") || formMap.containsKey("residenceNoUpd")
            			||formMap.containsKey("selectBranchUpd") || formMap.containsKey("meetingPointUpd")
            			|| formMap.containsKey("courseUpd") || formMap.containsKey("searchdepartmentUpd") || formMap.containsKey("inputSubDeptUpd")
            			|| formMap.containsKey("trNoUpd") || formMap.containsKey("areaIdUpd") || formMap.containsKey("addrDtlUpd")
            			|| formMap.containsKey("streetDtlUpd"))
            	{
            		EgovMap trainingItem = memberListService.selectMemCourse(formMap);

                    if(trainingItem != null && !trainingItem.isEmpty()) {
                        formMap.put("coursItmId", trainingItem.get("coursItmId"));
                        u5 = memberListService.memberListUpdate_MSC09(formMap);
                    }

                	Map<String, Object> returnVal = lmsApiService.lmsMemberListUpdate(formMap);
    				if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.FAIL)){
    					Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
    					throw new RuntimeException(e1);
    				}
            	}
            }

            if(formMap.get("memberType").toString().equals("7")) {
                u6 = memberListService.memberListUpdate_memorg3(formMap);
            }

            if(formMap.get("memberType").toString().equals("2")) {
                if(formMap.containsKey("codyPaExprUpd")) {
                    u7 = memberListService.memberListUpdate_ORG02(formMap);
                }
            }

            //logger.debug("Non-HP Update :: Branch :: u1 = " + Integer.toString(u1) + ", u2 = " + Integer.toString(u2));
            //logger.debug("Non-HP Update :: Member :: u3 = " + Integer.toString(u3));
            //logger.debug("Non-HP Update :: Applicant :: u4 = " + Integer.toString(u4));
            //logger.debug("Non-HP Update :: Course :: u5 = " + Integer.toString(u5));
            //logger.debug("Non-HP Update :: Service capacity :: u6 = " + Integer.toString(u6));
            //logger.debug("Non-HP Update :: CD PA :: u7 = " + Integer.toString(u7));
            // LaiKW - Comment ends here (New)

            // LaiKW - Comment starts here (Old)
            /*
            // Branch info update (SYS0047M, ORG0005D)
            resultUpc1 = memberListService.memberListUpdate_user(formMap);
            resultUpc2 = memberListService.memberListUpdate_memorg(formMap);
            // Member info update (ORG0001D)
            resultUpc3 = memberListService.memberListUpdate_member(formMap);
            // Member name update (Merge ORG0003D)
            resultUpc6 = memberListService.updateMemberName(formMap);
            if (formMap.get("memberType").toString().equals("2")) {
                memberListService.memberCodyPaUpdate(formMap);
            }
            String memType = (String) formMap.get("memType");
            logger.debug("================================================================================");
            logger.debug("=============== memType {} ", memType);
            logger.debug("================================================================================");

            if (memType.trim().equals("5")) {
                logger.debug("================================================================================");
                logger.debug("=============== insert =====================================");
                logger.debug("================================================================================");
                resultUpc4 = memberListService.traineeUpdateInfo(formMap, sessionVO);
            }

            if(memType.trim().equals("1")) {
                // Update ORG0003D aplicant meetpoint
                memberListService.updateMeetpoint(formMap);
            }

            if(memType.trim().equals("7")) {
                memberListService.memberListUpdate_memorg3(formMap);
            }
            */
            // LaiKW - Comment ends here (Old)

            /*if(memType.trim().equals("2")) {
                // Update ORG0003D CD agreement details
                memberListService.updateAplctDtls(formMap);
            }*/

            /*logger.debug("result UPC : " + Integer.toString(resultUpc1) + " , " + Integer.toString(resultUpc2) + " , "
                    + Integer.toString(resultUpc3) + " , " + Integer.toString(resultUpc6) + " , " );*/
        }

        else {
//            u3 = memberListService.memberListUpdate_ORG03(formMap);
            resultUpc5 = memberListService.hpMemberUpdate(formMap);

        }

        // 결과 만들기.
        ReturnMessage message = new ReturnMessage();
        // message.setCode(AppConstants.SUCCESS);
        // message.setData(map);
        if (memCode.equals("") && memCode.equals(null)) {
            message.setMessage("fail saved");
        } else {
            message.setMessage("Compelete to Edit a Member Code : " + memCode);
        }
        //logger.debug("message : {}", message + memCode);

        System.out.println("msg   " + success + memCode);
        //
        return ResponseEntity.ok(message);
    }
	/*
	@RequestMapping(value = "/getMemberListEditPop.do")
	public String getMemberListEditPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));

		EgovMap selectMemberListView = memberListService.selectMemberListView(params);
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
		// 호출될 화면
		return "organization/organization/memberListEditPop";
	}
	*/


	@RequestMapping(value = "/hpMemRegister.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  hpMemRegister(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws ParseException {

		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();

		//logger.debug("in...... hpMemRegister");
		//logger.debug("params : {}", params);

		try {
    		params.put("MemberID", Integer.parseInt((String) params.get("memberId")));

    		resultValue = memberListService.hpMemRegister(params,sessionVO);

    		//logger.debug("in...... hpMemRegiste Result");
    		//logger.debug("params : {}", params);
    		//logger.debug("resultValue : {}", resultValue);

    		if(resultValue.size() > 0){
    			if (resultValue.get("duplicMemCode") != null) {
    				message.setMessage("This member is already registered<br/>as member code : "
    						+ resultValue.get("duplicMemCode").toString());

    			} else {
    				message.setMessage((String)resultValue.get("memCode"));
    				// doc UPdate
    				params.put("hpMemId",  resultValue.get("memId").toString());
    				//logger.debug("params {}" , params);
    				memberListService.updateDocSubWhenAppr(params , sessionVO);

    			}
    		} else if (resultValue.size() == 0) {
    			message.setMessage("There is no address information to the HP applicant code");
    		}
		} catch (Exception e){
			message.setCode(AppConstants.FAIL);
			message.setMessage(e.getMessage());
		}

		//logger.debug("message : {}", message);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectSubDept.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubDept( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		//logger.debug("params {}", params);

		params.put("groupCode",  params.get("groupCode"));

		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;

		return ResponseEntity.ok( subDeptList);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCoureCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCoureCode( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		//logger.debug("selectCoureCode params : {}", params);


		Calendar Startcal = Calendar.getInstance();

		StringBuffer currDt = new StringBuffer();
		currDt.append(String.format("%04d", Startcal.get(Startcal.YEAR)));
		currDt.append(String.format("%02d", Startcal.get(Startcal.MONTH) + 1));
		currDt.append(String.format("%02d", Startcal.get(Startcal.DATE)));
		params.put("curDt", currDt.toString());

		Startcal.add(Calendar.MONTH,1);

		//현재 년도, 월, 일
	    StringBuffer today2 = new StringBuffer();
	    today2.append(String.format("%04d", Startcal.get(Startcal.YEAR)));
	    today2.append(String.format("%02d", Startcal.get(Startcal.MONTH) + 1));
        //today2.append(String.format("%02d",  01));

	    String startDay = today2.toString();

		Calendar Endcal = Calendar.getInstance();

		Endcal.add(Calendar.MONTH,2);
		//Endcal.set(year, month+3, day); //월은 -1해줘야 해당월로 인식

	    StringBuffer today3 = new StringBuffer();
	    today3.append(String.format("%04d", Endcal.get(Endcal.YEAR)));
	    today3.append(String.format("%02d", Endcal.get(Endcal.MONTH) + 1));

	    //today3.append(String.format("%02d", Endcal.getActualMaximum(Endcal.DAY_OF_MONTH)));

	    String endDay = today3.toString();
		//logger.debug("=====================todate2=========================" +startDay + " <>  " + endDay);

		params.put("startDay", startDay);
		params.put("endDay", endDay);

		List<EgovMap> deptCode = memberListService.selectCoureCode(params);
		return ResponseEntity.ok(deptCode);
	}

	@RequestMapping(value = "/selectDepartmentCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDepartmentCode(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> deptCode = memberListService.selectDepartmentCodeLit(params);
		return ResponseEntity.ok(deptCode);
	}

	@RequestMapping(value = "/selectBranchCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchCode(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> deptCode = memberListService.selectBranchCodeLit(params);
		return ResponseEntity.ok(deptCode);
	}

	@RequestMapping(value = "/checkNRIC1.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkNRIC1(@RequestParam Map<String, Object> params, Model model) {

//		logger.debug("nric : {} " + params.get("nric"));
//		String nric = "";
		//logger.debug("nric_params : {} " + params);
		List<EgovMap> checkNRIC1 = memberListService.checkNRIC1(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();

		if (checkNRIC1.size() > 0) {
			message.setMessage("This applicant had been registered");
		} else {
			message.setMessage("pass");
		}
		//logger.debug("message : {}", message);

    	return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkNRIC2.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkNRIC2(@RequestParam Map<String, Object> params, Model model) {

		//logger.debug("nric_params : {} " + params);
		List<EgovMap> checkNRIC2 = memberListService.checkNRIC2(params);
		String memType = "";
		String resignDt = "";
		String resignDtFlg = "";
		String status = "";

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();

		if (checkNRIC2.size() > 0) {
			memType = checkNRIC2.get(0).get("memType").toString();
			status = checkNRIC2.get(0).get("stus").toString();

			//logger.debug("memType : " + memType);
			//logger.debug("status : " + status);

			if(status.equals("51")) {
			    resignDt = checkNRIC2.get(0).get("resignDt").toString();
			    //logger.debug("resignDt : " + resignDt);

			    // 2019-02-12 - LaiKW - Amend checking for 6 months resignation allow rejoin
			    // 2020-08-38 - LaiKW - Amend checking for 3 months resignation allow rejoin
	            try{
	                String strDt = CommonUtils.getNowDate().substring(0,6) + "01";

	                // Current date - 6 months
	                Date cDt = new SimpleDateFormat("yyyyMMdd").parse(strDt);
	                Calendar cCal = Calendar.getInstance();
	                cCal.setTime(cDt);
	                cCal.add(Calendar.MONTH, -3);

	                //logger.debug("M-6 :: " + new SimpleDateFormat("dd-MMM-yyyy").format(cCal.getTime()));

	                Date rDt = new SimpleDateFormat("yyyyMMdd").parse(resignDt);
	                Calendar rCal = Calendar.getInstance();
	                rCal.setTime(rDt);

	                logger.debug("Resign :: " + new SimpleDateFormat("dd-MMM-yyyy").format(rCal.getTime()));
	                logger.debug("Resign :: " + new SimpleDateFormat("dd-MMM-yyyy").format(cCal.getTime()));

	                if(rCal.before(cCal)) {
	                    // Resignation Date is before 3 months before current date
	                    resignDtFlg = "Y";
	                }
	            } catch(Exception ex) {
	                ex.printStackTrace();
	                logger.error(ex.toString());
	            }

	            if(resignDtFlg.equals("Y")) {
                    message.setMessage("pass");
                } else {
                    message.setMessage("This member resigned less than 3 months.");
                }
			} else {
			    message.setMessage("This member is of active/terminate status.");
			}

			/*
			if (memType.equals("1") || memType.equals("2") || memType.equals("3") || memType.equals("4")) {
			//if (memType.equals("1") || memType.equals("2") || memType.equals("3") || memType.equals("4") || memType.equals("7")) {
			    message.setMessage("This member is our existing HP/Cody/Staff/CT");
			    //message.setMessage("This member is our existing HP/Cody/Staff/CT/HT");
			} else {
				message.setMessage("pass");
			}*/
		} else {
			message.setMessage("pass");
		}

		//logger.debug("message : {}", message);

    	return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkNRIC3.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkNRIC3(@RequestParam Map<String, Object> params, Model model) {

		//logger.debug("nric_params : {} " + params);
		List<EgovMap> checkNRIC3 = memberListService.checkNRIC3(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();

		if (checkNRIC3.size() > 0) {
			message.setMessage("Member must 18 years old and above");
		} else {
			message.setMessage("pass");
		}
		//logger.debug("message : {}", message);

    	return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkSponsor.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkSponsor(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {

		//logger.debug("checkSponsor_params : {} " + params);
		// modify jgkim

		if (sessionVO.getUserTypeId() == 1) {
			params.put("userTypeId", sessionVO.getUserTypeId());
			params.put("userId", sessionVO.getUserId());

			EgovMap item = new EgovMap();
			item = (EgovMap) memberListService.getOrgDtls(params);

			/*if(sessionVO.getMemberLevel() == 3) {
				logger.debug("3");
				params.put("deptCodeHd", item.get("lastDeptCode"));
				params.put("grpCodeHd", item.get("lastGrpCode"));
				params.put("orgCodeHd", item.get("lastOrgCode"));
			} else if(sessionVO.getMemberLevel() == 2) {
				logger.debug("2");
				params.put("deptCodeHd", item.get("lastDeptCode"));
				params.put("grpCodeHd", item.get("lastGrpCode"));
			} else if(sessionVO.getMemberLevel() == 1) {
				logger.debug("1");
				params.put("orgCodeHd", item.get("lastOrgCode"));
			}*/
//			params.put("deptCodeHd", item.get("lastDeptCode"));
//			params.put("grpCodeHd", item.get("lastGrpCode"));
			params.put("orgCodeHd", item.get("lastOrgCode"));
		}

		EgovMap checkSponsor = memberListService.checkSponsor(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();

		if (checkSponsor == null) {
			message.setMessage("There is no member code that you entered");
		} else {
			message.setData(checkSponsor);
			message.setMessage("ok");
		}
		//logger.debug("message : {}", message);

    	return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/selectBusinessType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBusinessType(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		List<EgovMap> course = memberListService.selectBusinessType();
		return ResponseEntity.ok(course);
	}


	/**
	 * MemberList Edit Pop open
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/memberListBranchEditPop.do")
	public String memberListBranchEditPop(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) {

		List<EgovMap> branch = memberListService.branch();
		//logger.debug("branchList : {}", branch);

		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));
		//logger.debug("params123 : {}", params);
		EgovMap selectMemberListView = null;
		if(!params.get("memType").toString().equals("2803")){ //hp가 아닐때
			selectMemberListView = memberListService.selectMemberListView(params);
		}
		else{
			selectMemberListView = memberListService.selectOneHPMember(params);
		}
		//logger.debug("selectMemberListView : {}", selectMemberListView);
		List<EgovMap>  selectIssuedBank =  memberListService.selectIssuedBank();
		//logger.debug("issuedBank : {}", selectIssuedBank);
		EgovMap ApplicantConfirm = memberListService.selectApplicantConfirm(params);
		//logger.debug("ApplicantConfirm : {}", ApplicantConfirm);
		EgovMap PAExpired = memberListService.selectCodyPAExpired(params);
		//logger.debug("PAExpired : {}", PAExpired);
		List<EgovMap> mainDeptList = memberListService.getMainDeptList();
		//logger.debug("mainDeptList : {}", mainDeptList);

		if(selectMemberListView != null){
    		params.put("groupCode", selectMemberListView.get("mainDept"));
    		//logger.debug("params : {}", params);
    		//logger.debug("groupCode : {}", selectMemberListView.get("mainDept"));
		}
		else{
			params.put("groupCode", "");
		}
    		List<EgovMap> subDeptList = memberListService.getSubDeptList(params) ;
    		//logger.debug("subDeptList : {}", subDeptList);

    	      // 2020-02-04 - LaiKW - Added to block CDB Sales admin to self change branch
            model.addAttribute("userRoleId", sessionVO.getRoleId());

		model.addAttribute("PAExpired", PAExpired);
		model.addAttribute("ApplicantConfirm", ApplicantConfirm);
		model.addAttribute("memberView", selectMemberListView);// 있어
		model.addAttribute("issuedBank", selectIssuedBank); //있어
		model.addAttribute("mainDeptList", mainDeptList);
		model.addAttribute("subDeptList", subDeptList);
		model.addAttribute("memType", params.get("memType"));
		model.addAttribute("memId", params.get("MemberID"));
		model.addAttribute("branch", branch);
		// 호출될 화면
		return "organization/organization/memberListBranchEditPop";
	}


	@RequestMapping(value = "/memberBranchUpdate", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateBranchMemberl(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {

		//memberListService.saveDocSubmission(memberListVO,params, sessionVO);

		Boolean success = false;
		String msg = "";



		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		int userId = sessionVO.getUserId();
		formMap.put("user_id", userId);

		//logger.debug("udtList : {}", updList);
		//logger.debug("formMap : {}", formMap);

		//logger.debug("memberNm : {}", formMap.get("memberNm"));
		//logger.debug("memberType : {}", formMap.get("memberType"));
		//logger.debug("joinDate : {}", formMap.get("joinDate"));
		//logger.debug("gender : {}", formMap.get("gender"));
		//logger.debug("update : {}", formMap.get("docType"));
		//logger.debug("myGridID : {}", formMap.get("params"));

		String memCode = "";
		boolean update = false;

		//logger.debug("memCode : {}", formMap.get("memCode"));

		//update

		memCode =  (String)formMap.get("memCode");

		int resultUpc1 = 0;
		int resultUpc2 = 0;
		int resultUpc3 = 0;
		int resultUpc4 = 0;
		int resultUpc5 = 0;
		/*20180918 - By KV - for service capacity update data purpose*/
		int resultUpc6 = 0;

		if( !formMap.get("memberType").toString().equals("2803") ){// hp가아닐때
    		resultUpc1 = memberListService.memberListUpdate_user(formMap);
    		resultUpc2 = memberListService.memberListUpdate_memorg(formMap);
    		resultUpc3 = memberListService.memberListUpdate_memorg2(formMap);
    		/*20180918 - By KV - for service capacity update data purpose*/
    		resultUpc6 = memberListService.memberListUpdate_memorg3(formMap);
		}
		// 결과 만들기.
   	ReturnMessage message = new ReturnMessage();
   	if(memCode.equals("") && memCode.equals(null)){
   		message.setMessage("fail saved");
   	}else{
   		message.setMessage("Compelete to Edit a Member Code : " +memCode);
   	}
   	//logger.debug("message : {}", message);

   	System.out.println("msg   " + success);
//
	return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/memberValidateUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateMemberValidate(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {


		Boolean success = false;
		String msg = "";

		int userId = sessionVO.getUserId();

		LinkedHashMap  ResultM = (LinkedHashMap)  params.get("ResultM");

		HashMap   mp= new HashMap();
		mp.put("membercode", ResultM.get("membercode"));
		mp.put("memberValidDt", ResultM.get("memberValidDt"));
		mp.put("user_id",userId);


		//logger.debug("Member Valid Result ===>"+mp.toString());

		//formMap.put("user_id", userId);


		String memCode = "";
		boolean update = false;

		////logger.debug("memCode : {}", formMap.get("memCode"));

		//update
		memCode =  (String)mp.get("membercode");

		 memberListService.MemberValidateUpdate(mp);

		// 결과 만들기.
   	ReturnMessage message = new ReturnMessage();
   	if(memCode.equals("") && memCode.equals(null)){
   		message.setMessage("fail saved");
   	}else{
   		message.setMessage("Compelete to Edit a Member Code : " +memCode);
   	}
   	//logger.debug("message : {}", message);

   	System.out.println("msg   " + success);
//
	return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/hpMemReject.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> rejectHPApproval(@RequestParam Map<String, Object> params, SessionVO sessionVO , Model model){
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();
		params.put("UpdUserId",userId);
		//logger.debug("params {}", params);
		boolean isHPApprovalReject = memberListService.updateHpApprovalReject(params);

		if(isHPApprovalReject){
			message.setMessage("success");
		}



		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/sponsorPop.do")
	public String sponsorPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		//logger.debug("sponsorPopUp.............");
		//logger.debug("params : {}", params);

//		params.put("MemberID", Integer.parseInt((String) params.get("MemberID")));

		// 2018-07-16 - LaiKW - Amend sponsor pop up search only limited to own department for HP only
		if(sessionVO.getUserTypeId() == 1) {
		    params.put("userId", sessionVO.getUserId());

		    EgovMap item = new EgovMap();
	        item = (EgovMap) memberListService.getOrgDtls(params);

		    model.addAttribute("orgCd", item.get("lastOrgCode"));
		}

		// 호출될 화면
		return "organization/organization/sponsorPop";
	}





		@RequestMapping(value = "/selectMemberType.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectMemberType(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {
			   //logger.debug("groupCode : {}", params);
//	           params.put("brnch_id", params.get("brnch_id")  );
//	           params.put("mem_id",params.get("mem_id") );
//	           params.put("mem_code",params.get("mem_code") );
			   List<EgovMap> selectMemberType = memberListService.selectMemberType(params);
			   return ResponseEntity.ok(selectMemberType);
		}




		@RequestMapping(value = "/selectSponBrnchList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSponBrnchList(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {
			   //logger.debug("groupCode : {}", params);
//	           params.put("brnch_id", params.get("brnch_id")  );
//	           params.put("mem_id",params.get("mem_id") );
//	           params.put("mem_code",params.get("mem_code") );
			   List<EgovMap> selectSponBrnchList = memberListService.selectSponBrnchList(params);
			   return ResponseEntity.ok(selectSponBrnchList);
		}




		@RequestMapping(value = "/sponMemberSearch.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSponMemberSearch(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
//logger.debug("params : {}", params);
			List<EgovMap> list =null;
	    	list = memberListService.selectSponMemberSearch(params);
			return ResponseEntity.ok(list);
		}


		@RequestMapping(value = "/selectAreaInfo.do", method = RequestMethod.GET)
		public ResponseEntity<EgovMap> selectAreaInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

			EgovMap areaInfo =null;
			areaInfo = memberListService.selectAreaInfo(params);
			//logger.debug("areaInfo : {}", areaInfo);
			return ResponseEntity.ok(areaInfo);
		}

		@RequestMapping(value = "/selectAllBranchCode.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectAllBranchCode(@RequestParam Map<String, Object> params) {
			List<EgovMap> codeList = memberListService.selectAllBranchCode();
			return ResponseEntity.ok(codeList);
		}

    // Agreement screen with custom login
    // Kit Wai - Start - 20180428
    @RequestMapping(value = "/getApplicantInfo", method = RequestMethod.GET)
    public ResponseEntity<Map> validateHpStatus(@RequestParam Map<String, Object> params, HttpServletRequest request,
            ModelMap model) {

        //logger.debug("==================== getApplicantInfo ====================");

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.validateHpStatus(params);

        Map<String, Object> aplicntStatus = new HashMap();
        aplicntStatus.put("id", item.get("aplctnId"));
        aplicntStatus.put("idntfc", item.get("idntfc"));
        aplicntStatus.put("stus", item.get("stusId"));
        aplicntStatus.put("cnfm", item.get("cnfm"));
        aplicntStatus.put("cnfm_dt", item.get("cnfmDt"));
        aplicntStatus.put("aplicntName", item.get("aplicntName"));
        aplicntStatus.put("aplicntNric", item.get("aplicntNric"));
        aplicntStatus.put("bnkNm", item.get("bnkNm"));
        aplicntStatus.put("aplicntBankAccNo", item.get("aplicntBankAccNo"));

        return ResponseEntity.ok(aplicntStatus);
    }

    @RequestMapping(value = "/agreementListing.do")
    public String agreementListing(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        //logger.debug("==================== agreementListing.do ====================");

        // Custom login checking based on URL input

        Precondition.checkNotNull(params.get("MemberID"),
                messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "Member ID" }));

        String idntfc = ((String) params.get("MemberID")).substring(0, 5);
        String memberID = ((String) params.get("MemberID")).substring(5);

        //logger.debug("Applicant ID : {}", memberID);
        //logger.debug("User Type : {}", idntfc);

        params.put("MemberID", memberID);
        params.put("Identification", idntfc);

        LoginVO loginVO = loginService.getAplcntInfo(params);

        String message = "";
        String status = "";

        if (loginVO == null || loginVO.getUserId() == 0) {
            status = "FAILED";
            message = "Aplicant does not exist";
        } else {
            HttpSession session = sessionHandler.getCurrentSession();
            session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));

            model.addAttribute("memberID", params.get("MemberID"));
            model.addAttribute("identification", params.get("Identification"));
        }

        model.addAttribute("status", status);
        model.addAttribute("message", message);
        return "organization/organization/memberHpAgreement";
    }

    @RequestMapping(value = "/updateHpCfm.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> updateAplicntInfo(@RequestParam Map<String, Object> params, ModelMap model)
            throws Exception {

        //logger.debug("==================== updateHpCfm.do ====================");

        //logger.debug("params {}", params);

        // Session
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
        params.put("userId", sessionVO.getUserId());
        if ("Y".equals(params.get("choice"))) {
            params.put("cnfm", "1");
            params.put("stusId", "102");
        } else {
            params.put("cnfm", "0");
            params.put("stusId", "6");
        }

        // service
        memberListService.updateHpCfm(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/sendEmail.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> sendEmail(@RequestParam Map<String, Object> params, HttpServletRequest request,
            ModelMap model, SessionVO session) {

        //logger.debug("==================== sendEmail.do ====================");

        //logger.debug("params {}", params);

        // send email
        EmailVO email = new EmailVO();
        email.setTo((String) params.get("recipient"));
        email.setHtml(true);
        email.setSubject("Health Planner Agreement Confirmation");

        String url = (String) params.get("url");
        String msg = "Dear Sir/Madam, <br /><br />"
                + "Thank you for register as Coway Health Planner. Please click the link below for confirmation of Health Planner Agreement. <br /><br />"
                + "<a href='" + url
                + "' target='_blank' style='color:blue; font-weight:bold'> Verify Now</a><br /><br />"
                + "Please note that you are able to view this Coway Health Planner Agreement for agreement confirmation within 7 days from your application date to complete your Health Planner registration.<br /><br />"
                + "This is a system generated email, please do not reply.<br /><br />" + "Thank you."
                + "<br /><br /><br />" + "Best Regards,<br /><b>Coway Malaysia</b>";

        email.setText(msg);

        boolean isResult = false;
        isResult = adaptorService.sendEmail(email, false);

        ReturnMessage message = new ReturnMessage();

        if (isResult == true) {
            message.setCode(AppConstants.SUCCESS);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/getHPCtc", method = RequestMethod.GET)
    public ResponseEntity<Map> getHPCtc(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== getHPCtc ====================");

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.getHPCtc(params);

        Map<String, Object> hpCtc = new HashMap();
        hpCtc.put("mobile", item.get("mobile"));
        hpCtc.put("email", item.get("email"));

        return ResponseEntity.ok(hpCtc);
    }

  //@AMEER INCOME_TAX 20190928
    @RequestMapping(value = "/checkIncomeTax", method = RequestMethod.GET)
    public ResponseEntity<Map> checkIncomeTax(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
        logger.debug("==================== checkIncomeTax ====================");
        Map<String, Object> incomeTaxCheck = new HashMap();

        EgovMap item = new EgovMap();
        params.put("srcM", "1");
        item = (EgovMap) memberListService.checkIncomeTax(params);
        //logger.debug("@@: 0"+item);
        incomeTaxCheck.put("cnt1", item.get("cnt"));

        params.remove("srcM");

        EgovMap item2 = new EgovMap();
        params.put("srcA", "1");
        item2 = (EgovMap) memberListService.checkIncomeTax(params);
        //logger.debug("@@: 0"+item2);
        incomeTaxCheck.put("cnt2", item2.get("cnt"));

        return ResponseEntity.ok(incomeTaxCheck);

    }

    @RequestMapping(value = "/verifyAccess", method = RequestMethod.GET)
    public ResponseEntity<Map> verifyAccess(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== verifyAccess ====================");
        //logger.debug("params{} " + params);

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.verifyAccess(params);

        Map<String, Object> verAccess = new HashMap();
        verAccess.put("cnt", item.get("cnt"));

        // 2019-08-22 - LaiKW - CR Cody/HP personal details verification
        if("1".equals(item.get("cnt").toString())) {
            EgovMap item2 = new EgovMap();
            item2 = (EgovMap) memberListService.getApplicantDetails(params);

            verAccess.put("verName", item2.get("aplicntName"));
            verAccess.put("verNRIC", item2.get("aplicntNric"));
            verAccess.put("verBankName", item2.get("bankName"));
            verAccess.put("verBankAccNo", item2.get("aplicntBankAccNo"));
         }

        return ResponseEntity.ok(verAccess);
    }

    @RequestMapping(value = "/checkBankAcc", method = RequestMethod.GET)
    public ResponseEntity<Map> checkBankAcc(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== checkBankAcc ====================");

        Map<String, Object> bankAccCheck = new HashMap();

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.checkBankAcc(params);
        bankAccCheck.put("cnt1", item.get("cnt"));

        return ResponseEntity.ok(bankAccCheck);
    }
    // Kit Wai - End - 20180428

    // Kit Wai - Start - 20190314
    // Added bank account number length checking
    @RequestMapping(value = "/checkAccLen", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> checkAccLen(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== checkAccLen ====================");

        ReturnMessage message = new ReturnMessage();

        String bankAccNo = params.get("bankAccNo").toString();

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.checkAccLen(params);

        String[] lenArr = item.get("accLen").toString().split("\\|\\|");;

        if(lenArr != null) {
            //String flg = ""
            for(int i = 0; i < lenArr.length; i++) {
                if(bankAccNo.length() == Integer.parseInt(lenArr[i])) {
                    message.setMessage("S");
                    break;
                } else {
                    message.setMessage("F");
                }
            }
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectAccBank.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectAccBank(@RequestParam Map<String, Object> params) throws Exception {

        logger.debug("==================== org-selectAccBank ====================");

        //logger.debug("groupCode : {}", params.get("groupCode"));

        List<EgovMap> codeList = memberListService.selectAccBank(params);
        return ResponseEntity.ok(codeList);
    }
    // Kit Wai - End - 20190314

    // 2018-06-14 - LaiKW - Cody agreement pop up and confirmation checking - Start
    @RequestMapping(value = "/cdAgreement.do")
    public String cdAgreement(@RequestParam Map<String, Object> params, ModelMap model) {

        logger.debug("==================== cdAgreement.do ====================");

        //logger.debug("params : {}", params);
        model.put("loginUserId", (String) params.get("loginUserId"));
        model.put("os", (String) params.get("os"));
        model.put("browser", (String) params.get("browser"));
        model.put("userId", (String) params.get("userId"));
        model.put("password", (String) params.get("password"));

        return "organization/organization/memberCodyAgreementPop";
    }

    @RequestMapping(value = "/updateCodyCfm.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> updateCodyCfm(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

        logger.debug("==================== updateCodyCfm.do ====================");

        //logger.debug("params {}", params);

        // Session
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
        params.put("userId", sessionVO.getUserName());
        //params.put("userType", sessionVO.getUserTypeId());
        if ("Y".equals(params.get("choice"))) {
            params.put("cnfm", "1");
            params.put("stusId", "5");
        } else {
            params.put("cnfm", "0");
            params.put("stusId", "6");
        }

        // service
        memberListService.updateCodyCfm(params);

        if(params.containsKey("consentFlg")) {
            if(!"".equals(params.get("consentFlg"))) {
                params.put("userId", sessionVO.getUserId());
                loginService.loginPopAccept(params);
            }
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/getCDInfo", method = RequestMethod.GET)
    public ResponseEntity<Map> getCDInfo(@RequestParam Map<String, Object> params, HttpServletRequest request,
            ModelMap model) {

        logger.debug("==================== getCDInfo ====================");

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.getCDInfo(params);

        Map<String, Object> cdStus = new HashMap();
        cdStus.put("id", item.get("aplctnId"));
        cdStus.put("stus", item.get("stusId"));
        cdStus.put("cnfm", item.get("cnfm"));
        cdStus.put("cnfm_dt", item.get("cnfmDt"));

        String status = "";
        String stusID = item.get("stusId").toString();
        String cnfm = item.get("cnfm").toString();
        String cnfmDt = item.get("cnfmDt").toString();

        if("1".equals(cnfm) && !"1900-01-01".equals(cnfmDt) && "5".equals(stusID)) {
            // Confirmed agreement
            status = "Y";
        } else if("0".equals(cnfm) && "1900-01-01".equals(cnfmDt) && "44".equals(stusID)) {
            // Unconfirmed agreement
            status = "N";
        } else if("0".equals(cnfm) && !"1900-01-01".equals(cnfmDt) && "6".equals(stusID)) {
            // Rejected agreement
            status = "R";
        }

        cdStus.put("status", status);

        return ResponseEntity.ok(cdStus);
    }
    // 2018-06-14 - LaiKW - Cody agreement pop up and confirmation checking - End

    // 2018-07-26 - LaiKW - Add HP Meeting Point drop down - Start
	@RequestMapping(value = "/selectHpMeetPoint.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		List<EgovMap> meetList = memberListService.selectHpMeetPoint();
		//logger.debug("return_Values: " + meetList.toString());

		return ResponseEntity.ok(meetList);
	}
	// 2018-07-26 - LaiKW - Add HP Meeting Point drop down - End

	@RequestMapping(value="/HPYSListingPop.do")
	public String HPYSListingPop(){

		return "organization/organization/HPYSListingPop";
	}

	@RequestMapping(value = "/selectMemberTypeHP.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberTypeHP(@RequestParam Map<String, Object> params) {
		List<EgovMap> memberTypeHP = memberListService.selectMemberTypeHP(params);
		return ResponseEntity.ok(memberTypeHP);
	}

	@RequestMapping(value = "/selectApprovalBranch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectApprovalBranch(@RequestParam Map<String, Object> params) {
		List<EgovMap> approvalBranch = memberListService.selectApprovalBranch(params);
		return ResponseEntity.ok(approvalBranch);
	}

	@RequestMapping(value = "/getHpAplctUrl.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getHpAplctUrl(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

	    EgovMap aplctnDtls = memberListService.getApplicantDetails(params);

	    return ResponseEntity.ok(aplctnDtls);
	}

	@RequestMapping(value = "/checkMemCode.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkMemCode(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
	    ReturnMessage message = memberListService.checkMemCode(params);
	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectTraining", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectTraining(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
        List<EgovMap> selectTraining = memberListService.selectTraining(params);
        //logger.debug("selectPromote : {}", selectTraining);
        return ResponseEntity.ok(selectTraining);
    }

	@RequestMapping(value = "/meetingPointMgmt.do")
	public String meetingPointMgmtPop(@RequestParam Map<String, Object> params, ModelMap model) {
	    return "organization/organization/meetingPointMgmtPop";
	}

    @RequestMapping(value = "/searchMP", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> searchMP(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
        List<EgovMap> searchMP = memberListService.searchMP(params);
        //logger.debug("selectPromote : {}", searchMP);
        return ResponseEntity.ok(searchMP);
    }

    @RequestMapping(value = "/getNextMPSeq", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> getNextMPSeq(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {

        int nextSeq = memberListService.getNextMPID();

        ReturnMessage message = new ReturnMessage();
        if(nextSeq != 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
            message.setData(nextSeq);
        } else {
            message.setCode(AppConstants.FAIL);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));

        }
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/saveMeetingPointGrid", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveMeetingPointGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model, SessionVO sessionVO) {

        int cnt = 0;
        List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE);
        List<Object> addList = params.get(AppConstants.AUIGRID_ADD);

        String userId = Integer.toString(sessionVO.getUserId());

        if(addList.size() > 0) {
            cnt = memberListService.addMeetingPoint(addList, userId);
        }

        if(updList.size() > 0) {
            cnt = memberListService.updMeetingPoint(updList, userId);
        }

        ReturnMessage message = new ReturnMessage();
        if(cnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/updateHPMeetingPoint", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateHPMeetingPoint(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {

        int cnt = 0;

        Map<String, MultipartFile> fileMap = request.getFileMap();
        MultipartFile multipartFile = fileMap.get("csvFile");
        List<HPMeetingPointUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, HPMeetingPointUploadVO::create);

        Map<String, Object> csvParam = new HashMap<String, Object>();
        csvParam.put("voList", vos);
        csvParam.put("userId", sessionVO.getUserId());

        List<HPMeetingPointUploadVO> vos2 = (List<HPMeetingPointUploadVO>) csvParam.get("voList");

        List<Map> hpMPList = vos2.stream().map(r -> {
            Map<String, Object> map = BeanConverter.toMap(r);

            map.put("memCode", r.getMemCode());
            map.put("memName", r.getMemName());
            map.put("meetpoint", r.getMeetpoint());

            return map;
        }).collect(Collectors.toList());

        Map<String, Object> map = new HashMap<>();
        map.put("userId", sessionVO.getUserId());
        map.put("list", hpMPList.stream().collect(Collectors.toCollection(ArrayList::new)));
        cnt = memberListService.updHPMeetingPoint(map);

        ReturnMessage message = new ReturnMessage();
        if(cnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/resetOrgPW.do")
    public String resetOrgPW(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

        String updUserId = memberListService.getUpdUserID(params);

        model.addAttribute("memberID", params.get("memberID"));
        model.addAttribute("updUserId", updUserId);

        return "organization/organization/resetOrgPW";
    }

    @RequestMapping(value = "/updateOrgUserPW.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateOrgUserPW(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        //logger.debug("params {}", params);

        params.put("userID", sessionVO.getUserId());
        int cnt = memberListService.updateOrgUserPW(params);

        ReturnMessage message = new ReturnMessage();
        if(cnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/promoDisHistory.do")
    public String eHpMemberList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

        params.put("groupCode",1);
        params.put("userTypeId", sessionVO.getUserTypeId());

        String type="";
        if (params.get("userTypeId" ) == "4" ) {
            type = memberListService.selectTypeGroupCode(params);
        } else {
            params.put("userTypeId", sessionVO.getUserTypeId());
        }

        //logger.debug("type : {}", type);

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
        List<EgovMap> user = memberListService.selectUser();


        model.addAttribute("memberType", memberType);
        model.addAttribute("user", user);

        params.put("userId", sessionVO.getUserId());
        EgovMap userRole = memberListService.getUserRole(params);
        model.addAttribute("userRole", userRole.get("roleid"));

        if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){
            EgovMap getUserInfo = salesCommonService.getUserInfo(params);
            model.put("promoDisHismemTypeCom", getUserInfo.get("memType"));
            model.put("orgCodeHd", getUserInfo.get("orgCode"));
            model.put("grpCodeHd", getUserInfo.get("grpCode"));
            model.put("deptCodeHd", getUserInfo.get("deptCode"));
            model.put("promoDisHisCode", getUserInfo.get("memCode"));
            logger.info("promoDisHismemTypeCom ##### " + getUserInfo.get("memType"));
        }


        return "organization/organization/promoDisHistory";
    }

    @RequestMapping(value = "/promoDisHistorySearch", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> promoDisHistorySearch(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        //logger.debug("memTypeCom : {}", params.get("promoDisHisMemTypeCom"));
        //logger.debug("promoDisHistorySearch - params : " + params);

        //logger.debug("memberLevel : {}", sessionVO.getMemberLevel());
        //logger.debug("userName : {}", sessionVO.getUserName());

        params.put("memberLevel", sessionVO.getMemberLevel());
        params.put("userName", sessionVO.getUserName());

        List<EgovMap> memberList = null;

        if (sessionVO.getUserTypeId() == 1) {
            params.put("userId", sessionVO.getUserId());

            EgovMap item = new EgovMap();
            item = (EgovMap) memberListService.getCurrOrgDtls(params);

            params.put("deptCodeHd", item.get("deptCode"));
            params.put("grpCodeHd", item.get("grpCode"));
            params.put("orgCodeHd", item.get("orgCode"));

        }

		memberList = memberListService.selectPromoDisHistory(params);

		return ResponseEntity.ok(memberList);
    }

    @RequestMapping(value = "/vaccinationListing.do")
    public String vaccinationListing(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        //logger.debug("==================== vaccinationListing.do ====================");

        // Custom login checking based on URL input
        Precondition.checkNotNull(params.get("MemberID"),
                messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "Member ID" }));

        String memCode = ((String) params.get("MemberID")).substring(6);
        String memberID = ((String) params.get("MemberID")).substring(0, 6);

        //logger.debug("Applicant ID : {}", memberID);
        //logger.debug("User Type : {}", memCode);

        params.put("MemberID", memberID);
        params.put("MemCode", memCode);

        LoginVO loginVO = loginService.getVaccineDeclarationAplcntInfo(params);

        String message = "";
        String status = "";

        if (loginVO == null || loginVO.getUserId() == 0) {
            status = "FAILED";
            message = "Aplicant does not exist";
        } else {
            HttpSession session = sessionHandler.getCurrentSession();
            session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));

            model.addAttribute("memberID", params.get("MemberID"));
            model.addAttribute("identification", params.get("Identification"));
        }

        model.addAttribute("status", status);
        model.addAttribute("message", message);
        return "organization/organization/vaccinationDeclaration";
    }

    @RequestMapping(value = "/getVaccineSubmitInfo", method = RequestMethod.GET)
    public ResponseEntity<Map> getVaccineSubmitInfo(@RequestParam Map<String, Object> params, HttpServletRequest request,
            ModelMap model) {

        //logger.debug("==================== getVaccineSubmitInfo ====================");

        EgovMap item = new EgovMap();
        item = (EgovMap) memberListService.validateVaccineDeclarationStatus(params);

        Map<String, Object> appDetails = new HashMap();
        appDetails.put("cnt", item.get("cnt"));

        if("0".equals(item.get("cnt").toString())) {
            EgovMap item2 = new EgovMap();
            item2 = (EgovMap) memberListService.getVaccineDeclarationMemDetails(params);

            appDetails.put("memID", item2.get("memId"));
            appDetails.put("memCode", item2.get("memCode"));
            appDetails.put("name", item2.get("name"));
            appDetails.put("nric", item2.get("nric"));
            appDetails.put("telMobile", item2.get("telMobile"));
            appDetails.put("email", item2.get("email"));
            appDetails.put("position", item2.get("memOrgDesc"));
         }

        return ResponseEntity.ok(appDetails);
    }

    @RequestMapping(value = "/updateVaccineDeclaration.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updateVaccineDeclaration(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO)
	          throws Exception {

    	logger.debug("==================== updateVaccineDeclaration.do ====================");

    	        //logger.debug("params {}", params);

    	        // Session
    	        sessionVO = sessionHandler.getCurrentSessionInfo();
    	        params.put("userId", sessionVO.getUserId());

    	        // service
    	        memberListService.updateVaccineDeclaration(params);

    	        ReturnMessage message = new ReturnMessage();
    	        message.setCode(AppConstants.SUCCESS);
    	        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return ResponseEntity.ok(message);

	}

    @RequestMapping(value = "/getVaccineListing", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> getVaccineListing(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO)
    		throws Exception {

        logger.debug("==================== getVaccineListing ====================");

        String memCode = ((String) params.get("MemberID"));
        String memberID = null;

        //logger.debug("Applicant ID : {}", memberID);
        //logger.debug("User Type : {}", memCode);

        Map<String, Object> details = new HashMap();
        //params.put("MemberID", memberID);
        details.put("MemCode", memCode);

        LoginVO loginVO = loginService.getVaccineDeclarationAplcntInfo(details);

        EgovMap item = new EgovMap();
        if(loginVO != null){
            params.put("memberID", loginVO.getUserId());
            item = (EgovMap) memberListService.validateVaccineDeclarationStatus(params);
        }

        ReturnMessage message = new ReturnMessage();
        if(loginVO != null){
        	if("0".equals(item.get("cnt").toString())) {
        		message.setCode(AppConstants.SUCCESS);
                message.setMessage("PENDING");
        	}else{
        		message.setCode(AppConstants.SUCCESS);
                message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        	}
        }else{
        	message.setCode(AppConstants.FAIL);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }


        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/memberSocialMediaPop.do")
	public String memberSocialMediaPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("MemberID", params.get("MemberID"));

        model.addAttribute("userRoleId", sessionVO.getRoleId());
		model.addAttribute("memType", params.get("memType"));
		model.addAttribute("MemberID", params.get("MemberID"));

		return "organization/organization/memberSocialMediaPop";
	}

    @RequestMapping(value = "/selectSocialMedia.do")
	public ResponseEntity<Map<String, Object>> selectSocialMedia(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    	logger.debug("==================== selectSocialMedia ====================");

		params.put("memberID", params.get("memberid"));

		EgovMap socialMedia = memberListService.selectSocialMedia(params);

        model.addAttribute("memCode", socialMedia.get("memCode"));
		model.addAttribute("memType", params.get("memType"));
		model.addAttribute("fbLink", socialMedia.get("fbLink"));
		model.addAttribute("igLink", socialMedia.get("igLink"));
		model.addAttribute("photoId", socialMedia.get("photoId"));
		model.addAttribute("fileSubPath", socialMedia.get("fileSubPath"));
		model.addAttribute("physiclFileName", socialMedia.get("physiclFileName"));

		return ResponseEntity.ok(model);
	}

    @RequestMapping(value = "/updateSocialMedia.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updateSocialMedia(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request, Model model, SessionVO sessionVO)
	          throws Exception {

  		logger.debug("==================== updateSocialMedia.do ====================");
  		//logger.debug("params1111" + params);

  		String atchSubPath = generateAttchmtSubPath();

	    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, atchSubPath, AppConstants.UPLOAD_MAX_FILE_SIZE, true);

	    params.put(CommonConstants.USER_ID, sessionVO.getUserId());

	    //logger.debug("== REQUEST FILE LISTING {} ", list);
	    //logger.debug("== REQUEST FILE SIZE " + list.size());

	    if (list.size() > 0) {
	      params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
	      int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
	      params.put("photoId", fileGroupKey);
	    }

	    memberListService.updateSocialMedia(params);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return ResponseEntity.ok(message);
	}

    public String generateAttchmtSubPath(){
		Date today = new Date();
		SimpleDateFormat formatAttchtDt = new SimpleDateFormat("yyyyMMdd");
		String dt = formatAttchtDt.format(today);
		String subPath = File.separator + "mem_HP" + File.separator  + dt.substring(0, 4) + File.separator + dt.substring(0, 6);
		return subPath;
	}



    @RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {

    	logger.debug("params =====================================>>  " + params);

    	params.put("MemberID", params.get("memId"));

    	EgovMap socialMedia = memberListService.selectSocialMedia(params);

		Map<String, Object> attachInfo = new HashMap<String, Object>();
		attachInfo.put("atchFileGrpId", socialMedia.get("atchFileGrpId"));
		attachInfo.put("atchFileId", socialMedia.get("atchFileId"));

		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(attachInfo);

		return ResponseEntity.ok(fileInfo);
	}
}

