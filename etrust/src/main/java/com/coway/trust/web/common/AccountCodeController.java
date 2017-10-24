package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/account")
public class AccountCodeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AccountCodeController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/accountCode.do")
	public String listAccountCode(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		LOGGER.debug("listAccountCode");
		return "common/accountCodeManagement";
	}

	@RequestMapping(value = "/selectAccountCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAccountCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> accountCodeList = commonService.getAccountCodeList(params);

		return ResponseEntity.ok(accountCodeList);
	}

	/**
	 * POPUP 화면 호출.
	 */
	@RequestMapping(value = "/accountCodeEditPop.do")
	public String accountCodeUpdPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// popup 화면으로 넘길 데이터.
		model.addAttribute("inputParams", params);

		// 호출될 화면
		return "common/accountCodeManagementPop";
	}

	@RequestMapping(value = "/accountCodeAddPop.do")
	public String accountCodeAddPop(@RequestParam Map<String, Object> params) {
		// 호출될 화면
		return "/common/accountCodeManagementPop";
	}

	/**
	 * ACCOUNT CODE INSERT
	 */
	@RequestMapping(value = "/insertAccount.do")
	public ResponseEntity<ReturnMessage> insertAccountCode(@RequestBody Map<String, Object> params, ModelMap model,
			SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		if (!"EDIT".equals(params.get("popUpSaveFlag"))) {
			int accountCodeCount = commonService.getAccCodeCount(params);

			if (accountCodeCount > 0) {
				message.setCode(AppConstants.FAIL);
				message.setMessage("CODE [" + params.get("popUpAccCode") + "] Exists Already.");
				return ResponseEntity.ok(message);
			}
		}

		((Map<String, Object>) params).put("crtUserId", sessionVO.getUserId());
		((Map<String, Object>) params).put("updUserId", sessionVO.getUserId());

		if ("on".equals(String.valueOf(params.get("popUpIsPayCash")))) {
			params.put("popUpIsPayCash", 1);
		} else {
			params.put("popUpIsPayCash", 0);
		}

		if ("on".equals(String.valueOf(params.get("popUpIsPayChq")))) {
			params.put("popUpIsPayChq", 1);
		} else {
			params.put("popUpIsPayChq", 0);
		}

		if ("on".equals(String.valueOf(params.get("popUpIsPayOnline")))) {
			params.put("popUpIsPayOnline", 1);
		} else {
			params.put("popUpIsPayOnline", 0);
		}

		if ("on".equals(String.valueOf(params.get("popUpIsPayCrc")))) {
			params.put("popUpIsPayCrc", 1);
		} else {
			params.put("popUpIsPayCrc", 0);
		}

		int cnt = commonService.mergeAccountCode(params);

		// 호출될 화면
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
