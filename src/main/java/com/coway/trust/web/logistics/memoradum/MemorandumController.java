/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.memoradum;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.coway.trust.biz.logistics.memorandum.MemorandumService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/memorandum")
public class MemorandumController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "memosvc")
	private MemorandumService memo;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/MemoList.do")
	public String stockTransferDeliveryList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/Memorandum/memorandumList";
	}

	@RequestMapping(value = "/memoSearchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectMemoList(@RequestBody Map<String, Object> params, Model model) throws Exception {

		List<EgovMap> list = memo.selectMemoRandumList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/memoDelete.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> memoDelete(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		memo.memoDelete(params);

		ReturnMessage msg = new ReturnMessage();
		msg.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/memoSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertMemoSave(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		params.put("userid", loginId);

		ReturnMessage msg = new ReturnMessage();

		Map<String, Object> data = memo.memoSave(params);
		msg.setData(data);

		return ResponseEntity.ok(msg);
	}

}
