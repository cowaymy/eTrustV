package com.coway.trust.web.organization.organization;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.coway.trust.biz.enquiry.EnquiryService;
import com.coway.trust.biz.organization.organization.MemberAccessService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class MemberAccessController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MemberAccessController.class);

	@Resource(name = "memberAccessService")
	private MemberAccessService memberAccessService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "EnquiryService")
	 private EnquiryService enquiryService;


	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**
	 * Call member eligibility Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberAccess.do")
	public String memberAccess(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		params.put("groupCode",1);
		params.put("userTypeId", sessionVO.getUserTypeId());

		List<EgovMap> memberType = commonService.selectCodeList(params);
		model.addAttribute("memberType", memberType);


		return "organization/organization/memberAccess";
	}

	@RequestMapping(value = "/searchPosition.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>positionList (@RequestParam Map<String, Object> params, ModelMap model){
		return ResponseEntity.ok(memberAccessService.selectPosition(params));
	}

	@RequestMapping(value = "/memberAccessListSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectmemberListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO,
			@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());

		List<EgovMap> memberList = null;

		params.put("sessionTypeID", sessionVO.getUserTypeId());
		if (sessionVO.getUserTypeId() == 1) {
			params.put("userId", sessionVO.getUserId());

			EgovMap item = new EgovMap();
			item = (EgovMap) memberAccessService.getOrgDtls(params);

			params.put("deptCodeHd", item.get("lastDeptCode"));
			params.put("grpCodeHd", item.get("lastGrpCode"));
			params.put("orgCodeHd", item.get("lastOrgCode"));

		}

		String MemType = params.get("memTypeCom").toString();
		memberList = memberAccessService.selectMemberAccessList(params);

		return ResponseEntity.ok(memberList);
	}

	@RequestMapping(value = "/selectMemberAccessDetailPop.do")
	public String selectMemberAccessDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

//		logger.debug("selCompensation in.............");
//		logger.debug("params: {}", params);

		LOGGER.debug("params for View =====================================>>  " + params);
		EgovMap selectMemberAccessListView = null;

		selectMemberAccessListView = memberAccessService.selectMemberAccessListView((String) params.get("memberCode"));

		model.put("memberAccess", selectMemberAccessListView);


		// 호출될 화면
		return "organization/organization/memberAccessDetailPop";
	}

	@RequestMapping(value = "/registrationMsgPop.do")
	public String registrationMsgPop(@RequestParam Map<String, Object> params,ModelMap model) {

		LOGGER.debug("registrationMsgPop.do=====================>>  " + params.toString());

		model.put("memCode",  params.put("memCode", params.get("memCode")));
		model.put("userName",  params.put("userName", params.get("userName")));
		model.put("requestCategory", params.put("requestCategory", params.get("requestCategory")));
		model.put("caseCategory", params.put("caseCategory", params.get("caseCategory")));
		model.put("remark1", params.put("remark1", params.get("remark1")));
		model.put("effectDt", params.put("effectDt", params.get("effectDt")));

		return "organization/organization/registrationMsgPop";
	}


	@RequestMapping(value = "/checkApproval.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkApproval(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO)  throws Exception{

        LOGGER.debug("params checkApproval =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();

        // checking if already has same request
        /*int subCount = memberAccessService.checkExistRequest(params.get("memCode").toString());*/

    	List<Object> apprGridList = (List<Object>) params.get("apprGridList");

        if (apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for (Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                appvLineUserId.add(hm.get("memCode").toString());
            }

            String finAppvLineUserId = appvLineUserId.get(appvLineUserId.size() - 1);
            LOGGER.debug("params finAppvLineUserId =====================================>>  " + finAppvLineUserId);

            //String  memCodeApproval = memberAccessService.getFinApprover();
            // hardcode the final approver
            String memCode = "P0002";
            /*LOGGER.debug("params memCodeApproval =====================================>>  " + memCodeApproval);
            if(memCodeApproval == null){
            	memCode = "0";
            }
            else{
            	memCode = memCodeApproval;
            }*/
            LOGGER.debug("checkApproval.memCode =====================================>>  " + memCode);

            memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
            if(!finAppvLineUserId.equals(memCode)) {
            	LOGGER.debug("FAIL!");
            	message.setCode(AppConstants.FAIL);
                message.setData(params);
                message.setMessage("Wrong Approval, Please re-select");
            } else {
            	LOGGER.debug("SUCCESS!");
                message.setCode(AppConstants.SUCCESS);
                message.setData(params);
            }
        }

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value="/memberAccessApproveView.do")
	public String approveToResetMFAPop(ModelMap model, SessionVO sessionVO){
		Map<String, Object> p = new HashMap();
		p.put("type", "approval");
		p.put("curr", sessionVO.getMemId());
		model.put("requests", new Gson().toJson(memberAccessService.accessApprovalList(p)));
		return "organization/organization/memberAccessApproveView";
	}

	@RequestMapping(value = "/checkExistMemCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkExistMemCode(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params requestResultM =====================================>>  " + params);

		int cnt = memberAccessService.checkExistMemCode(params);

		ReturnMessage message = new ReturnMessage();

		if(cnt > 0) {
			message.setCode(AppConstants.FAIL);
			message.setMessage("This member code already been requested.");
		} else {
			message.setCode(AppConstants.SUCCESS);
		}
		message.setData(cnt);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(@RequestParam Map<String, Object> params,ModelMap model) {

		LOGGER.debug("approveLinePop.do=====================>>  " + params.toString());

		model.put("memCode",  params.put("memCode", params.get("memCode")));
		model.put("userName",  params.put("userName", params.get("userName")));
		model.put("requestCategory", params.put("requestCategory", params.get("requestCategory")));
		model.put("caseCategory", params.put("caseCategory", params.get("caseCategory")));
		model.put("remark1", params.put("remark1", params.get("remark1")));
		model.put("effectDt", params.put("effectDt", params.get("effectDt")));
		return "organization/organization/memberAccessApproveLine";
	}

	@RequestMapping(value = "/completedMsgPop.do", method = RequestMethod.POST)
	public String completedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("memCode", params.get("memCode"));
		return "organization/organization/completedMsgPop";
	}

	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String requestID = memberAccessService.selectNextRequestID();
		params.put("requestID", requestID);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO
		memberAccessService.insertApproveManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@Transactional
	@RequestMapping(value="/approveBlock.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveBlock(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {
		ReturnMessage message = new ReturnMessage();
		try {
			Map<String, Object> data = new Gson().fromJson(request.getParameter("data"), HashMap.class);
			data.put("userId", sessionVO.getUserId());

			if ((boolean) data.get("approve")) {
				data.put("stus", 5);
				int updateAccess = memberAccessService.updateAccess(data);
			} else {
				data.put("stus", 6);
			}

			memberAccessService.updateApproval(data);


			message.setCode(AppConstants.SUCCESS);
		} catch(Exception e) {
			 Map<String, Object> errorParam = new HashMap<>();
			 errorParam.put("pgmPath","/organization");
			 errorParam.put("functionName", "approveBlock.do?userId=" + sessionVO.getUserId());
			 errorParam.put("errorMsg",CommonUtils.printStackTraceToString(e));
			 enquiryService.insertErrorLog(errorParam);

			 message.setCode(AppConstants.FAIL);


			 //message.setMessage("This member code failed to be update.");
		}
		return ResponseEntity.ok(message);
	}

/*	@RequestMapping(value="/blockListUpdate.do", method=RequestMethod.POST)
    public ResponseEntity<ReturnMessage> blockListUpdate(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {

		ReturnMessage message = new ReturnMessage();

		try{
			int mainData = 0 , detailsResult= 0;
			Map<String, Object> data = new Gson().fromJson(request.getParameter("data"), HashMap.class);
			data.put("userId",  sessionVO.getUserId());
			masterResult = memberListService.insertMfaResetRequest(data);

			int currentId = memberListService.selectCurrRequestId();

			List<HashMap<String, Object>> approvalLine = (List<HashMap<String, Object>>) data.get("members");

			for(int i = 0; i < approvalLine.size(); i++) {
				Map<String, Object> d = (Map<String, Object>) approvalLine.get(i);
				d.put("reqId", currentId);
				d.put("seq", i+1);
				detailsResult = memberListService.insertMfaApprovalLine(d);
			}

			message.setCode(masterResult > 0 && detailsResult > 0 ? AppConstants.SUCCESS:AppConstants.FAIL);
			message.setMessage(masterResult > 0 && detailsResult > 0 ? "Success to submit." : "Fail to submit.");
		}catch(Exception e){
			 Map<String, Object> errorParam = new HashMap<>();
			 errorParam.put("pgmPath","/organization");
			 errorParam.put("functionName", "submitMfaResetRequest.do?userId=" + sessionVO.getUserId());
			 errorParam.put("errorMsg",CommonUtils.printStackTraceToString(e));
			 enquiryService.insertErrorLog(errorParam);

			 message.setCode(AppConstants.FAIL);
			 message.setMessage("Fail to submit.");
		}
		 return ResponseEntity.ok(message);
	}*/


}
