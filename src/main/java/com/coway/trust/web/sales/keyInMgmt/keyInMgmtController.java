package com.coway.trust.web.sales.keyInMgmt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.keyInMgmt.keyInMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/keyInMgmt")
public class keyInMgmtController {

  private static final Logger LOGGER = LoggerFactory.getLogger(keyInMgmtController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Resource(name = "keyInMgmtService")
  private keyInMgmtService keyInMgmtService;

  @RequestMapping(value = "/selectKeyInMgmtList.do")
  public String selectKeyInMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/order/keyInMgmtList";
  }

  @RequestMapping(value = "/searchKeyinMgmtList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProgramList(@RequestParam Map<String, Object> params) {
		List<EgovMap> KeyinMgmtList = keyInMgmtService.searchKeyinMgmtList(params);

		return ResponseEntity.ok(KeyinMgmtList);
	}

  @RequestMapping(value = "/saveKeyInId.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveKeyInId(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD);
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);

		int totCnt = keyInMgmtService.saveKeyInId(addList, udtList, delList, sessionVO.getUserId());

		LOGGER.info("upd : {}", udtList.toString());
		LOGGER.info("add : {}", addList.toString());
		LOGGER.info("del : {}", delList.toString());
		LOGGER.info("cnt : {}", totCnt);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
