package com.coway.trust.web.logistics.itembt;

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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.itembt.TRBookService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "logistic/TRBook")
public class TRBookController {

	private static final Logger logger = LoggerFactory.getLogger(TRBookController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "trBookService")
	private TRBookService trBookService;

	@RequestMapping(value = "/TRBookManagement.do")
	public String TRBookManagement(@RequestParam Map<String, Object> params) {

		return "logistics/ItemBT/trBookManagement";
	}

	@RequestMapping(value = "/searchTRBookManagement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchTRBookManagement(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		String branch = sessionVO.getBranchName();
		String close = "";

		if ("".equals(branch) || null == branch) {
			branch = "HQ";
		}
		List<Object> stutus = (List<Object>) params.get("ddlBookStatus");
		logger.info("stutus : {} ", stutus.toString());
		if (0 < stutus.size()) {
			for (int i = 0; i < stutus.size(); i++) {
				int tmp = Integer.parseInt(String.valueOf(stutus.get(i)));
				if (36 == tmp) {
					params.put("Close", close);
				}
			}
		}

		params.put("branch", branch);
		params.put("stutus", stutus);

		List<EgovMap> list = trBookService.selectTrBookManagement(params);
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}
}
