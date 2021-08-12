package com.coway.trust.web.organization.organization;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
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
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.ComplianceCallLogService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/organization/compliance")
public class ComplianceCallLogController {
	private static final Logger logger = LoggerFactory.getLogger(ComplianceCallLogController.class);

	@Resource(name = "complianceCallLogService")
	private ComplianceCallLogService complianceCallLogService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	/**
	 * Organization Compliance Call Log
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initComplianceCallLog.do")
	public String initComplianceCallLog(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "organization/organization/complianceCallLog";
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceCallLog.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectComplianceLog(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		String[] caseStatusList = request.getParameterValues("caseStatus");
		params.put("caseStatusList", caseStatusList);
		List<EgovMap> complianceList = complianceCallLogService.selectComplianceLog(params);
		logger.debug("complianceList : {}",complianceList);
		return ResponseEntity.ok(complianceList);
	}

	/**
	 * Organization Compliance Call Log new
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceCallLogNewPop.do")
	public String complianceCallLogNewPop(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "organization/organization/complianceCallLogNewPop";
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getMemberDetail.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> gettMemberDetail(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap complianceMemDetail = complianceCallLogService.getMemberDetail(params);
		logger.debug("complianceList : {}",complianceMemDetail);
		return ResponseEntity.ok(complianceMemDetail);
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCompliance.do", method = RequestMethod.POST)
	public ResponseEntity <ReturnMessage> insertCompliance(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVo) {

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<EgovMap> insList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ALL);
		/*List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);*/

		logger.debug("insList : {}",insList);
		/*logger.debug("updList : {}",updList);
		logger.debug("remList : {}",remList);*/

		String comPlianceNo = complianceCallLogService.insertCompliance(formMap,sessionVo,insList);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(comPlianceNo);
		return ResponseEntity.ok(message);
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCheckOrderNo.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> getCheckOrderNo(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap checkOrder = complianceCallLogService.selectCheckOrder(params);
		logger.debug("checkOrder : {}",checkOrder);
		return ResponseEntity.ok(checkOrder);
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getComplianceOrderDetail.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> getComplianceOrderDetail(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap orderDetailGrid = complianceCallLogService.selectComplianceOrderDetail(params);
		logger.debug("orderDetail : {}",orderDetailGrid);
		return ResponseEntity.ok(orderDetailGrid);
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceOrderFullDetailPop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String complianceOrderFullDetail(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVO);

		logger.debug("orderDetail : {}",orderDetail);
		model.addAttribute("orderDetail", orderDetail);
		return "organization/organization/complianceOrderFullDetailPop";
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/uploadAttachPop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String uploadAttachPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {

		return "organization/organization/attachmentFileUploadPop";
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		logger.debug("in  updateReTrBook ");
		logger.debug("params =====================================>>  " + params);


		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "ComplianceLog" + File.separator + "ComplianceLog", 1024 * 1024 * 6);

		params.put("userId", sessionVO.getUserId());
		params.put("branchId", sessionVO.getUserBranchId());
		params.put("deptId", sessionVO.getUserDeptId());

		params.put("list", list);

		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", params.get("fileName").toString());

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params.get("fileGroupKey"));
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}


	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/complianceLogMaintencePop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String complianceLogMaintencePop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {

		EgovMap complianceValue = complianceCallLogService.selectComplianceNoValue(params);
		logger.debug("complianceValue : {}",complianceValue);
		model.addAttribute("complianceValue",complianceValue);

		return "organization/organization/complianceCallLogMaintenancePop";
	}



		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/orderDetailComplianceId.do", method = RequestMethod.GET)
		public ResponseEntity <List<EgovMap>> getOrderDetailComplianceId(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
			List<EgovMap> orderDetailList = complianceCallLogService.selectOrderDetailComplianceId(params);
			logger.debug("orderDetail : {}",orderDetailList);
			return ResponseEntity.ok(orderDetailList);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/complianceRemark.do", method = RequestMethod.GET)
		public ResponseEntity <List<EgovMap>> getComplianceRemark(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
			List<EgovMap> complianceRemarkList = complianceCallLogService.selectComplianceRemark(params);
			logger.debug("complianceRemarkList : {}",complianceRemarkList);
			return ResponseEntity.ok(complianceRemarkList);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/deleteOrderDetail.do", method = RequestMethod.GET)
		public ResponseEntity<ReturnMessage> deleteOrderDetail(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
			boolean success = false;
			logger.debug("params : {}",params);
			success = complianceCallLogService.deleteOrderDetail(params);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(success);
			return ResponseEntity.ok(message);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/saveComplianceOrderDetail.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> saveComplianceOrderDetail(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model,HttpServletRequest request, SessionVO sessionVo) {

			List<Object> gridList =  params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
			List<Object> formList =  params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
			logger.debug("gridList : {}",gridList);
			logger.debug("formList : {}",formList);
			Map<String, Object> formMap = new HashMap<String, Object>();
			if (formList.size() > 0) {

	    		formList.forEach(obj -> {
	                Map<String, Object> map = (Map<String, Object>) obj;
	                formMap.put((String)map.get("name"),map.get("value"));
	    		});
	    	}

			boolean success = false;
			success = complianceCallLogService.insertComplianceOrderDetail(gridList,formMap);
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(success);
			return ResponseEntity.ok(message);
		}


		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/saveMaintenceCompliance.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> insertMaintenceCompliance(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVo) {
			boolean success = false;
			logger.debug("params : {}",params);
			success = complianceCallLogService.saveMaintenceCompliance(params,sessionVo);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(success);
			return ResponseEntity.ok(message);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws ExceptionsaveCompliance
		 */
		@RequestMapping(value = "/saveOrderMaintence.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> saveOrderMaintence(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVo) {
			boolean success = false;
			logger.debug("params : {}",params);
			success = complianceCallLogService.saveOrderMaintence(params,sessionVo);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(success);
			return ResponseEntity.ok(message);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/complianceViewPop.do", method = {RequestMethod.POST,RequestMethod.GET})
		public String selectComplianceView(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {
			EgovMap complianceValue = complianceCallLogService.selectComplianceNoValue(params);
			logger.debug("complianceValue : {}",complianceValue);
			model.addAttribute("complianceValue",complianceValue);
			return "organization/organization/complianceViewPop";
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/complianceAttachDownload.do", method = RequestMethod.GET)
		public ResponseEntity <EgovMap> complianceAttachDownload(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
			EgovMap fileDownload = complianceCallLogService.selectAttachDownload(params);
			logger.debug("fileDownload : {}",fileDownload);
			return ResponseEntity.ok(fileDownload);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws ExceptionsaveCompliance
		 */
		@RequestMapping(value = "/saveOrderMaintenceSync.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> saveOrderMaintenceSync(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVo) {
			boolean success = false;
			logger.debug("params : {}",params);
			success = complianceCallLogService.saveOrderMaintenceSync(params,sessionVo);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(success);
			return ResponseEntity.ok(message);
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/complianceCallReOpenPop.do", method = {RequestMethod.POST,RequestMethod.GET})
		public String complianceCallReOpenPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {
			logger.debug("params : {}",params);
			model.addAttribute("complianceId", params.get("complianceId"));
			model.addAttribute("memberId", params.get("memberId"));
			return "organization/organization/complianceCallLogReOpenPop";
		}

		/**
		 * Compliance Call Log Search
		 *
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/saveComplianceReopen.do", method = RequestMethod.POST)
		public ResponseEntity <ReturnMessage> saveComplianceReopen(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVo) {

			//Map<String , Object> formMap1 = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
			/*List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
			List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);*/

			/*logger.debug("updList : {}",updList);
			logger.debug("remList : {}",remList);*/

			String comPlianceNo = complianceCallLogService.insertComplianceReopen(params,sessionVo);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(comPlianceNo);
			return ResponseEntity.ok(message);
		}

		@RequestMapping(value = "/getPicList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> getPicList(@RequestParam Map<String, Object>params) {
	        // Member Type 에 따른 Organization 조회.
			List<EgovMap> resultList = complianceCallLogService.getPicList(params);

			return ResponseEntity.ok(resultList);
		}

}
