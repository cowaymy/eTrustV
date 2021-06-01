package com.coway.trust.web.organization.organization;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.GroupService;
import com.coway.trust.biz.sales.customer.LoyaltyHpService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.sales.customer.LoyaltyHpRawDataVO;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class MemberGroupListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MemberGroupListController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "groupService")
	private GroupService groupService;

	/*
	 * @RequestMapping(value = "/loyaltyHp.do") public String loyaltyHpUploadList(@RequestParam Map<String, Object>
	 * params, ModelMap model) throws Exception {
	 * 
	 * return "sales/customer/loyaltyHpUploadList"; }
	 */

	@RequestMapping(value = "groupUploadPop.do")
	public String groupUploadPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		return "/organization/organization/groupUploadPop";
	}

	@RequestMapping(value = "/groupCsvUpload", method = RequestMethod.POST)
	public ResponseEntity readFile(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request,
			SessionVO sessionVO) throws IOException, InvalidFormatException {
		LOGGER.debug("groupCsvUpload params =============================>>  " + params);
		ReturnMessage message = new ReturnMessage();
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<GroupRawDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, GroupRawDataVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		for (GroupRawDataVO vo : vos) {

			HashMap<String, Object> hm = new HashMap<String, Object>();

			hm.put("fromTrans", vo.getFromTrans().trim());
			hm.put("memberCode", vo.getMemberCode().trim());
			hm.put("toTrans", vo.getToTrans().trim());
			hm.put("memberLevel", vo.getMemberLevel().trim());
			hm.put("transDate", vo.getTransDate().trim());
			hm.put("memberCodeTo", vo.getMemberCodeTo().trim());
			hm.put("groupMemberType", vo.getGroupMemberType().trim());
			hm.put("crtUserId", sessionVO.getUserId());
			hm.put("updUserId", sessionVO.getUserId());

			detailList.add(hm);
		}

		Map<String, Object> master = new HashMap<String, Object>();

		master.put("crtUserId", sessionVO.getUserId());
		master.put("updUserId", sessionVO.getUserId());
		master.put("groupRem", "Group Transfer File Upload");
		master.put("groupTotItm", vos.size());
		master.put("groupTotSuccess", 0);
		master.put("groupTotFail", 0);

		int result = groupService.saveCsvUpload(master, detailList);
		if (result > 0) {

			message.setMessage("Group Transfer File successfully uploaded.<br />Batch ID : " + result);
			message.setCode(AppConstants.SUCCESS);
		} else {
			message.setMessage("Failed to upload Group Transfer File. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectGroupMstList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGroupMstList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> list = groupService.selectGroupMstList(params);

		LOGGER.debug("list =====================================>>  " + list.toString());
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/groupDetailViewPop.do")
	public String loyaltyHpDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);

		EgovMap groupBatchInfo = groupService.selectGroupInfo(params);

		model.addAttribute("groupBatchInfo", groupBatchInfo);
		model.addAttribute("groupBatchItem", new Gson().toJson(groupBatchInfo.get("groupBatchItem")));

		return "organization/organization/groupDetailViewPop";
	}

	@RequestMapping(value = "/groupConfirm")
	public ResponseEntity<ReturnMessage> groupConfirm(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		groupService.callGroupConfirm(params);

		String msg = null;
		if (params.get("v_sqlcode") != null)
			msg = "(" + params.get("v_sqlcode") + ")" + params.get("v_sqlcont");
		System.out.println("##msg : " + msg);

		message.setMessage(msg);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/groupReject")
	public ResponseEntity<ReturnMessage> groupReject(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		int result = groupService.updGroupReject(params);

		if (result > 0) {

			message.setMessage("Group Transfer File successfully rejected.<br />");
			message.setCode(AppConstants.SUCCESS);
		} else {
			message.setMessage("Failed to reject Group Transfer File. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);

	}

}
