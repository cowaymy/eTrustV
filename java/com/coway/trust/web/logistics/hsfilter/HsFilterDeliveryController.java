package com.coway.trust.web.logistics.hsfilter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.logistics.hsfilter.HsFilterDeliveryService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/HsFilterDelivery")

public class HsFilterDeliveryController {

  private static final Logger LOGGER = LoggerFactory.getLogger(HsFilterDeliveryController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Resource(name = "HsFilterDeliveryService")
  private HsFilterDeliveryService hsFilterDeliveryService;

  @Resource(name = "stocktranService")
  private StockTransferService stock;


  @RequestMapping(value = "/hsFilterDeliveryList.do")
  public String hsFilterDeliveryList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)



    return "logistics/hsfilter/hsFilterDeliveryList";
  }




  @RequestMapping(value = "/hsFilterDeliveryPickingList.do")
  public String hsFilterDeliveryPickingList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후) change



    return "logistics/hsfilter/hsFilterDeliveryPickingList";
  }



	@RequestMapping(value = "/selectHSFilterDeliveryBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSFilterDeliveryBranchList(@RequestParam Map<String, Object> params) {

		//logger.debug("searchBranch@@@@@: {}", params.get("searchBranch"));

		//if (!"".equals(params.get("searchBranch")) || null != params.get("searchBranch")){

		//	String tmp = params.get("searchBranch").toString();
		//	params.put("cdcCodeList", tmp);
		//}


		List<EgovMap> list = hsFilterDeliveryService.selectHSFilterDeliveryBranchList(params);
		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/selectHSFilterDeliveryList.do")
	public ResponseEntity<List<EgovMap>> selectHSFilterDeliveryList(@RequestParam Map<String, Object> params) throws Exception {


		hsFilterDeliveryService.selectHSFilterDeliveryList(params);
		List<EgovMap> list =(List<EgovMap>) params.get("cv_1");


		return ResponseEntity.ok(list);
	}




	@RequestMapping(value = "/selectHSFilterDeliveryPickingList.do")
	public ResponseEntity<List<EgovMap>> selectHSFilterDeliveryPickingList(@RequestParam Map<String, Object> params) throws Exception {


		hsFilterDeliveryService.selectHSFilterDeliveryPickingList(params);

		List<EgovMap> list =(List<EgovMap>) params.get("cv_1");
		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/saveSTOAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSTOAdd(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVo) {

		int userId = sessionVo.getUserId();
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ALL);


		LOGGER.debug(params.toString());

		params.put("userId", userId);

		String reqNo = hsFilterDeliveryService.insertStockTransferInfo(params); //SMO

		params.put("reqNo", reqNo);

		List<EgovMap> list = hsFilterDeliveryService.selectStockTransferRequestItem(params);

		String data = hsFilterDeliveryService.StocktransferReqDelivery(list,userId);


		LOGGER.info("reqNo"+reqNo);
		LOGGER.info("data"+data);

		ReturnMessage message = new ReturnMessage();
		if (reqNo != null && !"".equals(reqNo)){
		// 결과 만들기 예.
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		message.setData(reqNo + ' ' + data);

		return ResponseEntity.ok(message);
	}



}
