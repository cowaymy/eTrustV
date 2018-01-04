package com.coway.trust.web.logistics.stockmovement;

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
import com.coway.trust.biz.logistics.stockmovement.StockMovementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/stockMovement")
public class StockMovementController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "stockMovementService")
	private StockMovementService stockMovementService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/StockMovementIns.do")
	public String stockins(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/stockMovement/stockMovementIns";
	}

	@RequestMapping(value = "/StockMovementAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> stockMovementService(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("form", formMap);
		param.put("userId", loginId);
		String reqNo =stockMovementService.insertStockMovementInfo(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(reqNo);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StockMovementList.do")
	public String stocklist(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String streq = request.getParameter("streq");
		String sttype = request.getParameter("sttype");
		String smtype = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt = request.getParameter("crtsdt");
		String crtedt = request.getParameter("crtedt");
		String reqsdt = request.getParameter("reqsdt");
		String reqedt = request.getParameter("reqedt");
		String smvpath = request.getParameter("smvpath");
		String sstatus = request.getParameter("sstatus");
		String rStcode = request.getParameter("rStcode");

		Map<String, Object> map = new HashMap();
		map.put("streq", streq);
		map.put("sttype", sttype);
		map.put("smtype", smtype);
		map.put("tlocation", tlocation);
		map.put("flocation", flocation);
		map.put("crtsdt", crtsdt);
		map.put("crtedt", crtedt);
		map.put("reqsdt", reqsdt);
		map.put("reqedt", reqedt);
		map.put("smvpath", smvpath);
		map.put("sstatus", sstatus);

		model.addAttribute("searchVal", map);

		return "logistics/stockMovement/stockMovementList";
	}

	@RequestMapping(value = "/selectStockMovementNo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = stockMovementService.selectStockMovementNoList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/StockMovementSearchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockMovementSearchList(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		List<EgovMap> list = stockMovementService.selectStockMovementMainList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StockMovementRequestDeliveryList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectStockMovementRequestDeliveryList(@RequestParam Map<String, Object> params,
			Model model) throws Exception {

		List<EgovMap> list = stockMovementService.selectStockMovementDeliveryList(params);
		List<EgovMap> mtrList = stockMovementService.selectStockMovementMtrDocInfoList(params);
		Map<String, Object> map = new HashMap();
		map.put("data", list);
		map.put("data2", mtrList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StockMovementTolocationItemList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectStockTransferTolocationItemList(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO type SQL.xml 다이나믹 처리 필요
		String[] type = request.getParameterValues("cType");
		String toloc = request.getParameter("slocation");
		String mcode = request.getParameter("materialCode");
		
		// logger.debug("type : {}", type);
		Map<String, Object> smap = new HashMap();
		smap.put("ctype", type);
		smap.put("toloc", toloc);
		smap.put("mcode", mcode);
		
		List<EgovMap> list = stockMovementService.selectTolocationItemList(smap);

		smap.put("data", list);

		return ResponseEntity.ok(smap);
	}

	@RequestMapping(value = "/StockMovementView.do", method = RequestMethod.POST)
	public String selectStockMovementView(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String streq = request.getParameter("streq");
		String sttype = request.getParameter("sttype");
		String smtype = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt = request.getParameter("crtsdt");
		String crtedt = request.getParameter("crtedt");
		String reqsdt = request.getParameter("reqsdt");
		String reqedt = request.getParameter("reqedt");
		String smvpath = request.getParameter("smvpath");
		String sstatus = request.getParameter("sstatus");
		String rStcode = request.getParameter("rStcode");

		Map<String, Object> map = new HashMap();
		map.put("streq", streq);
		map.put("sttype", sttype);
		map.put("smtype", smtype);
		map.put("tlocation", tlocation);
		map.put("flocation", flocation);
		map.put("crtsdt", crtsdt);
		map.put("crtedt", crtedt);
		map.put("reqsdt", reqsdt);
		map.put("reqedt", reqedt);
		map.put("smvpath", smvpath);
		map.put("sstatus", sstatus);

		model.addAttribute("searchVal", map);
		model.addAttribute("rStcode", rStcode);

		return "logistics/stockMovement/stockMovementView";
	}

	@RequestMapping(value = "/StockMovementItemDeliveryQty.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectStockMovementItemDeliveryQty(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String toloc = request.getParameter("toloc");
		String itmcd = request.getParameter("itmcd");
		int iCnt = 0;
		Map<String, Object> map = new HashMap();
		map.put("toloc", toloc);
		map.put("itmcd", itmcd);

		iCnt = stockMovementService.stockMovementItemDeliveryQty(map);

		map.put("iqty", iCnt);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StockMovementDataDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stocktransferDataDetail(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String rstonumber = request.getParameter("rStcode");

		Map<String, Object> map = stockMovementService.selectStockMovementDataDetail(rstonumber);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StockMovementReqItemDelete.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> stockMovementReqItemDelete(@RequestBody Map<String, Object> params,
			Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();

		List<Object> delList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> param = new HashMap();
		param.put("del", delList);
		param.put("form", formMap);
		param.put("userId", loginId);

		stockMovementService.deleteDeliveryStockMovement(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StockMovementReqAdd.do", method = RequestMethod.POST)
	public ResponseEntity<Map> stockMovementReqAdd(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {

		int loginId = sessionVO.getUserId();

		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("upd", updList);
		param.put("form", formMap);
		param.put("userId", loginId);

		List<EgovMap> list = stockMovementService.addStockMovementInfo(param);

		Map<String, Object> rmap = new HashMap();
		rmap.put("data", list);
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		rmap.put("message", message);

		return ResponseEntity.ok(rmap);
	}

	/**
	 * Delivery view
	 * 
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/StockMovementListDelivery.do")
	public String stocklistdelivery(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String streq = request.getParameter("streq");
		String sttype = request.getParameter("sttype");
		String smtype = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt = request.getParameter("crtsdt");
		String crtedt = request.getParameter("crtedt");
		String reqsdt = request.getParameter("reqsdt");
		String reqedt = request.getParameter("reqedt");
		String smvpath = request.getParameter("smvpath");
		String sstatus = request.getParameter("sstatus");
		String rStcode = request.getParameter("rStcode");

		Map<String, Object> map = new HashMap();
		map.put("streq", streq);
		map.put("sttype", sttype);
		map.put("smtype", smtype);
		map.put("tlocation", tlocation);
		map.put("flocation", flocation);
		map.put("crtsdt", crtsdt);
		map.put("crtedt", crtedt);
		map.put("reqsdt", reqsdt);
		map.put("reqedt", reqedt);
		map.put("smvpath", smvpath);
		map.put("sstatus", sstatus);
		model.addAttribute("searchVal", map);

		return "logistics/stockMovement/stockMovementListDelivery";
	}

	/**
	 * Delivery Number issues
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/StockMovementReqDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> stockMovementReqDelivery(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);

		Map<String , Object> map = stockMovementService.stockMovementReqDelivery(params);
		
		logger.debug(" :::: {}" , map);
		
		String reVal = (String)map.get("rdata");		
		String returnValue[] = reVal.split("∈");
		
		for (int i = 0 ; i < returnValue.length ; i++){
			returnValue[i] = returnValue[i].replaceAll(" ", "");
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(returnValue);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StockMovementSerialCheck.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockMovementSerialCheck(@RequestParam Map<String, Object> params) {

		logger.debug("serial : {}", params.get("serial"));

		List<EgovMap> list = stockMovementService.selectStockMovementSerial(params);
		Map<String, Object> rmap = new HashMap();

		rmap.put("data", list);
		return ResponseEntity.ok(rmap);
	}

	@RequestMapping(value = "/StockMovementReceiptList.do")
	public String stockMovementReceiptList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/stockMovement/stockMovementReceiptList";
	}

	@RequestMapping(value = "/StockMovementGoodIssue.do", method = RequestMethod.POST)
	public ResponseEntity<Map> stockMovementGoodIssue(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);
		Map<String, Object> rmap = stockMovementService.stockMovementDeliveryIssue(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		logger.debug(" :::: {} " , rmap);
		if ("fail".equals((String)rmap.get("retMsg"))){
			message.setCode(AppConstants.FAIL);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}else{
    		message.setCode(AppConstants.SUCCESS);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}

		rmap.put("message", message);

		return ResponseEntity.ok(rmap);
	}

	@RequestMapping(value = "/StockMoveSearchDeliveryList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> StocktransferSearchDeliveryList(@RequestBody Map<String, Object> params, Model model)
			throws Exception {

		List<EgovMap> list = stockMovementService.selectStockMovementDeliveryList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	/**
	 * View Serial Pop up In Good Receipt
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "/StockMovementDeliverySerialView.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockMovementDeliverySerialView(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		List<EgovMap> list = stockMovementService.selectStockMovementDeliverySerial(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/GetSerialDataCall.do", method = RequestMethod.GET)
	public ResponseEntity<Map> GetSerialDataCall(@RequestParam Map<String, Object> params, Model model)
			throws Exception {
		
		logger.debug("445 Line ::: {} " , params);

		List<EgovMap> list = stockMovementService.selectGetSerialDataCall(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
}
