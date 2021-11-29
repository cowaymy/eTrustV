/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.stocktransfer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.biz.logistics.stockmovement.StockMovementService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;
import com.coway.trust.cmmn.exception.PreconditionException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/stocktransfer")
public class StocktransferController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "stocktranService")
	private StockTransferService stock;

	@Resource(name = "stockMovementService")
	private StockMovementService stockMovementService;

	@Resource(name = "serialMgmtNewService")
	private SerialMgmtNewService serialMgmtNewService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/StocktransferIns.do")
	public String stockins(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/StockTrans/StockTransferIns";
	}

	@RequestMapping(value = "/StockTransferDeliveryList.do")
	public String stockTransferDeliveryList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/StockTrans/StockTransferDeliveryList";
	}

	@RequestMapping(value = "/StockTransferReceiptList.do")
	public String StockTransferReceiptList(ModelMap model) throws Exception {
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("nextDate", CommonUtils.getAddDay(toDay, +6, SalesConstants.DEFAULT_DATE_FORMAT1));
        model.put("toDay", toDay);

		return "logistics/StockTrans/StockTransferReceiptList";
	}

	@RequestMapping(value = "/test.do")
	public String StockTransfertest(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/StockTrans/test";
	}

	@RequestMapping(value = "/StocktransferList.do")
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
		String sam = request.getParameter("sam");
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
		map.put("sam", sam);
		map.put("sstatus", sstatus);

		model.addAttribute("searchVal", map);

		return "logistics/StockTrans/StockTransferList";
	}

	@RequestMapping(value = "/StocktransferListDelivery.do")
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
		String sam = request.getParameter("sam");
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
		map.put("sam", sam);
		map.put("sstatus", sstatus);
		model.addAttribute("searchVal", map);

		return "logistics/StockTrans/StockTransferListDelivery";
	}

	@RequestMapping(value = "/StocktransferView.do", method = RequestMethod.POST)
	public String stockview(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String streq = request.getParameter("streq");
		String sttype = request.getParameter("sttype");
		String smtype = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt = request.getParameter("crtsdt");
		String crtedt = request.getParameter("crtedt");
		String reqsdt = request.getParameter("reqsdt");
		String reqedt = request.getParameter("reqedt");
		String sam = request.getParameter("sam");
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
		map.put("sam", sam);
		map.put("sstatus", sstatus);

		model.addAttribute("searchVal", map);
		model.addAttribute("rStcode", rStcode);

		return "logistics/StockTrans/StockTransferView";
	}

	@RequestMapping(value = "/StocktransferSearchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationList(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVo)
			throws Exception {

		int userId = sessionVo.getUserId();

		params.put("userId", userId);
		List<EgovMap> list = stock.selectStockTransferMainList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StocktransferRequestDeliveryList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> StocktransferRequestDeliveryList(@RequestParam Map<String, Object> params, Model model,SessionVO sessionVo)
			throws Exception {

		List<EgovMap> list = stock.selectStockTransferDeliveryList(params);
		List<EgovMap> mtrList = stock.selectStockTransferMtrDocInfoList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);
		map.put("data2", mtrList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StocktransferAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferAdd(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		int userId = sessionVo.getUserId();
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("form", formMap);
		param.put("userId", userId);
		String reqNo = stock.insertStockTransferInfo(param);

		logger.debug("reqNo!!!!! : {}", reqNo);
		ReturnMessage message = new ReturnMessage();
		if (reqNo != null && !"".equals(reqNo)){
		// 결과 만들기 예.
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		message.setData(reqNo);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StocktransferReqAdd.do", method = RequestMethod.POST)
	public ResponseEntity<Map> StocktransferReqAdd(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {

		int userId = sessionVo.getUserId();
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("upd", updList);
		param.put("form", formMap);
		param.put("userId", userId);

		List<EgovMap> list = stock.addStockTransferInfo(param);

		Map<String, Object> rmap = new HashMap();
		rmap.put("data", list);
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		rmap.put("message", message);

		return ResponseEntity.ok(rmap);
	}

	@RequestMapping(value = "/selectStockTransferNo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = stock.selectStockTransferNoList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/StocktransferDataDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map> StocktransferDataDetail(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String rstonumber = request.getParameter("rStcode");

		Map<String, Object> map = stock.StocktransferDataDetail(rstonumber);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/stockTransferItemDeliveryQty.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockTransferItemDeliveryQty(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String toloc = request.getParameter("toloc");
		String itmcd = request.getParameter("itmcd");
		int iCnt = 0;
		Map<String, Object> map = new HashMap();
		map.put("toloc", toloc);
		map.put("itmcd", itmcd);

		iCnt = stock.stockTransferItemDeliveryQty(map);

		map.put("iqty", iCnt);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/stockTransferTolocationItemList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockTransferTolocationItemList(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String[] catetype = request.getParameterValues("catetype");
		String[] type = request.getParameterValues("cType");
		String toloc = request.getParameter("slocation");
		String mcode = request.getParameter("materialCode");

		Map<String, Object> smap = new HashMap();
		smap.put("catetype", catetype);
		smap.put("ctype", type);
		smap.put("toloc", toloc);
		smap.put("mcode", mcode);

		List<EgovMap> list = stock.selectTolocationItemList(smap);

		smap.put("data", list);

		return ResponseEntity.ok(smap);
	}

	@RequestMapping(value = "/StocktransferDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferDelivery(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {

		int userId = sessionVo.getUserId();
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		// Map<String , Object> formMap = (Map<String, Object>) formList.get(0);

		Map<String, Object> param = new HashMap();
		param.put("upd", updList);
		param.put("form", formMap);
		param.put("userId", userId);

		stock.deliveryStockTransferInfo(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StocktransferReqItemDelete.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferReqItemDelete(@RequestBody Map<String, Object> params,
			Model model, SessionVO sessionVo) {
		int userId = sessionVo.getUserId();
		List<Object> delList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		// Map<String , Object> formMap = (Map<String, Object>) formList.get(0);

		Map<String, Object> param = new HashMap();
		param.put("del", delList);
		param.put("form", formMap);
		param.put("userId", userId);

		stock.deliveryStockTransferItmDel(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

//	@RequestMapping(value = "/StocktransferReqDelivery.do", method = RequestMethod.POST)
//	public ResponseEntity<ReturnMessage> StocktransferReqDelivery(@RequestBody Map<String, Object> params, Model mode,
//			SessionVO sessionVo) {
//		int userId = sessionVo.getUserId();
//
//		logger.debug("params : {}", params.toString());
//		// List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
//
//		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
//		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
//		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
//
//		Map<String, Object> param = new HashMap();
//		param.put("check", updList);
//		param.put("add", serialList);
//		param.put("formMap", formMap);
//		param.put("userId", userId);
//
//		String data = stock.StocktransferReqDelivery(param);
//
//		// 결과 만들기 예.
//		ReturnMessage message = new ReturnMessage();
//		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		message.setData(data);
//		return ResponseEntity.ok(message);
//	}

	@RequestMapping(value = "/StocktransferReqDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferReqDelivery(@RequestBody Map<String, Object> params, Model mode,
			SessionVO sessionVo) {
		int userId = sessionVo.getUserId();

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		Map<String, Object> param = new HashMap();
		param.put("check", list);
		param.put("userId", userId);

		String data = stock.StocktransferReqDelivery(param);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(data);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StocktransferSearchDeliveryList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> StocktransferSearchDeliveryList(@RequestBody Map<String, Object> params, Model mode,SessionVO sessionVo)
			throws Exception {
		int userId = sessionVo.getUserId();
		params.put("userId", userId);
		List<EgovMap> list = stock.selectStockTransferDeliveryList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}


	// Befor goods issue
	@RequestMapping(value = "/StocktransferGoodIssue.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferGoodIssue(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) throws Exception {
		int userId = sessionVo.getUserId();
		String delyno = "";

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		ReturnMessage message = new ReturnMessage();

		String gtype= (String) formMap.get("gtype");

		logger.debug("gtype @@@@@@@: {}", gtype);

		if("RC".equals(gtype)){

			List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

    		params.put("userId", userId);
    		params.put("add", serialList);

    		String reVal = stock.StockTransferDeliveryIssue(params);

    		// 결과 만들기 예.

    		message.setCode(AppConstants.SUCCESS);
    		message.setData(reVal);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		}else{

    		if (checklist.size() > 0) {
    			for (int i = 0; i < checklist.size(); i++) {
    				Map<String, Object> map = (Map<String, Object>) checklist.get(i);

    				Map<String, Object> imap = new HashMap();
    				imap = (Map<String, Object>) map.get("item");

    				delyno = (String) imap.get("delyno");

    			}
    		}

    		logger.debug("delyno ??????: {}", delyno);

    		Map<String, Object> grlist = stock.selectDelvryGRcmplt(delyno);

    		if(null == grlist){
    			throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
    		}

    		String grmplt =(String) grlist.get("DEL_GR_CMPLT");
    		String gimplt =(String) grlist.get("DEL_GI_CMPLT");

    		logger.debug("grmplt    값 : {}", grmplt);
    		logger.debug("gimplt    값 : {}", gimplt);


    		if ("Y".equals(gimplt)){
    			message.setCode(AppConstants.FAIL);
    			message.setMessage("Already processed.");
    		}else{

        		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

        		params.put("userId", userId);
        		params.put("add", serialList);

        		String reVal = stock.StockTransferDeliveryIssue(params);

        		// 결과 만들기 예.

        		message.setCode(AppConstants.SUCCESS);
        		message.setData(reVal);
        		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
	}
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StocktransferGRGoodIssue.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferGRGoodIssue(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) throws Exception {
		int userId = sessionVo.getUserId();
		String delyno = "";

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		ReturnMessage message = new ReturnMessage();
		String gtype= (String) formMap.get("gtype");

		logger.debug("gtype @@@@@@@: {}", gtype);


		if("RC".equals(gtype)){

			List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

    		params.put("userId", userId);
    		params.put("add", serialList);

    		String reVal = stock.StockTransferDeliveryIssue(params);

    		// 결과 만들기 예.

    		message.setCode(AppConstants.SUCCESS);
    		message.setData(reVal);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		}else{

		if (checklist.size() > 0) {
			for (int i = 0; i < checklist.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checklist.get(i);

				Map<String, Object> imap = new HashMap();
				imap = (Map<String, Object>) map.get("item");

				delyno = (String) imap.get("delyno");

			}
		}

		logger.debug("delyno ??????: {}", delyno);

		Map<String, Object> grlist = stock.selectDelvryGRcmplt(delyno);

		if(null == grlist){
			throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
		}

		String grmplt =(String) grlist.get("DEL_GR_CMPLT");
		String gimplt =(String) grlist.get("DEL_GI_CMPLT");

		logger.debug("grmplt    값 : {}", grmplt);
		logger.debug("gimplt    값 : {}", gimplt);



		if ("Y".equals(grmplt)){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Already processed.");
		}else{

    		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

    		params.put("userId", userId);
    		params.put("add", serialList);

    		String reVal = stock.StockTransferDeliveryIssue(params);

    		// 결과 만들기 예.

    		message.setCode(AppConstants.SUCCESS);
    		message.setData(reVal);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		}
}

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/StocktransferDeliveryDelete.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferDeliveryDelete(@RequestBody Map<String, Object> params,
			Model mode, SessionVO sessionVo) {
		int userId = sessionVo.getUserId();

		logger.debug("params : {}", params.toString());
		// List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		//List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		//Map<String, Object> param = new HashMap();
		//param.put("check", updList);
		params.put("userId", userId);

		stock.StocktransferDeliveryDelete(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/deleteStoNo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> deleteStoNo(@RequestParam Map<String, Object> params,
			Model model) {

		if (!params.isEmpty()){
			//stock.deleteStoNo(params);
			logger.info("###params: " + params.toString());
			params.put("reqsmono", params.get("reqstono"));

    		// share using method to delete SMO.
    		stockMovementService.deleteSmoNo(params);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectDelNo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectDelNo(@RequestParam Map<String, Object> params,
			Model model) {

		int delchk = stock.selectDelNo(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(delchk);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/stockMaxQtyCheck.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockMaxQtyCheck(@RequestParam Map<String, Object> params,
			Model model) {

		logger.debug(" :::: {} ", params);

		String chkYn = stock.selectMaxQtyCheck(params);
		Map<String, Object> map = new HashMap();
		map.put("chkyn" , chkYn);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectDefLocation.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectDefLocation(@RequestParam Map<String, Object> params,
			Model model,SessionVO sessionVo) {

		int userBrnchId = sessionVo.getUserBranchId();

		params.put("userBrnchId", userBrnchId);

		logger.debug(" selectDefLocation params {} ", params);

		String defLoc = stock.selectDefLocation(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(defLoc);

		return ResponseEntity.ok(message);
	}



	// Good Issue 팝업
	@RequestMapping(value = "/stoIssuePop.do")
	public String serialScanInPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("url", params);

		String toDay = CommonUtils.getFormattedString("dd/MM/yyyy");
		model.put("toDay", toDay);

		return "logistics/StockTrans/stoIssuePop";
	}

	// delivery별 스캔 리스트 조회
	@RequestMapping(value = "/selectStoIssuePop.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectStoIssuePop(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		ReturnMessage result = new ReturnMessage();

		List<EgovMap> list = stock.selectStoIssuePop(params);

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		result.setTotal(list.size());
		return ResponseEntity.ok(result);

	}

	@RequestMapping(value = "/StocktransferGoodIssueNew.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferGoodIssueNew(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) throws Exception {
		int userId = sessionVo.getUserId();
		String delyno = "";

		ReturnMessage message = new ReturnMessage();

		String gtype= (String) params.get("gtype");
		//logger.debug("gtype @@@@@@@: {}", gtype);

		delyno = (String)params.get("zDelvryNo");

		//logger.debug("delyno : {}", delyno);
		if(StringUtils.isEmpty(delyno)){
			throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
		}

		Map<String, Object> grlist = stock.selectDelvryGRcmplt(delyno);
		if(grlist == null){
			throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
		}

		//HLTANG 202111 - filter scan barcode
		params.put("reqstNo", params.get("zDelvryNo"));
		//update status 'D' to 'C'
		serialMgmtNewService.saveSerialNo(params, sessionVo);

		String grmplt =(String) grlist.get("DEL_GR_CMPLT");
		String gimplt =(String) grlist.get("DEL_GI_CMPLT");
		//logger.debug("grmplt    값 : {}", grmplt);
		//logger.debug("gimplt    값 : {}", gimplt);

		if ("Y".equals(gimplt)){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Already processed.");
		}else{
    		params.put("userId", userId);
    		String reVal = stock.StockTransferDeliveryIssueNew(params, sessionVo);

    		message.setCode(AppConstants.SUCCESS);
    		message.setData(reVal);
    		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	}

		return ResponseEntity.ok(message);
	}


	/**
	 * Call Good Receipt Popup
	 * @Author KR-SH
	 * @Date 2019. 12. 5.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/goodReceiptPop.do")
	public String goodReceiptPop(@RequestParam Map<String, Object> params, ModelMap model) {
		String toDay = CommonUtils.getFormattedString("dd/MM/yyyy");
		model.put("gipDate", toDay);

		return "logistics/StockTrans/goodReceiptPop";
	}

	/**
	 * Search Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 5.
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goodReceiptPopList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> goodReceiptPopList(@RequestParam Map<String, Object>params) throws Exception {
		String delyno = CommonUtils.nvl(params.get("delyno")); 		// Delivery No List
		String[] arrDelyList = null;

		if(delyno.indexOf(",") > -1)  arrDelyList = delyno.split(",");
		params.put("arrDelyList", arrDelyList);
		params.put("delyno", delyno);

		// 데이터 리턴.
		return ResponseEntity.ok(stock.goodReceiptPopList(params));
	}


	/**
	 * Save Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 6.
	 * @param params
	 * @param sessionVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/StockTransferDeliveryIssueSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StockTransferDeliveryIssueSerial(@RequestBody Map<String, Object> params, SessionVO sessionVo) throws Exception {
		ReturnMessage message = new ReturnMessage();
		String delyno = CommonUtils.nvl(params.get("delyno"));
		String[] delvcd = {delyno};

		Map<String, Object> grlist = stock.selectDelvryGRcmplt(delyno);

		if(null == grlist) {
			throw new PreconditionException(AppConstants.FAIL, "DelvryNO does not exist.");
		}
		if ("Y".equals(CommonUtils.nvl(grlist.get("DEL_GR_CMPLT")))) {
			message.setCode(AppConstants.FAIL);
			message.setMessage("Already processed.");

		}else{
    		params.put("parray", delvcd);
    		params.put("sGrDate", CommonUtils.nvl(params.get("giptdate")));
    		params.put("sGipfdate", CommonUtils.nvl(params.get("gipfdate")));
    		params.put("sGiptdate", CommonUtils.nvl(params.get("giptdate")));
    		params.put("zGtype", CommonUtils.nvl(params.get("gtype")));
    		params.put("dryNo", delyno);
    		params.put("userId", CommonUtils.intNvl(sessionVo.getUserId()));

    		//HLTANG 202111 - filter scan barcode
    		params.put("reqstNo", params.get("delyno"));
    		//update status 'D' to 'C'
    		serialMgmtNewService.saveSerialNo(params, sessionVo);

    		message = stock.StockTransferDeliveryIssueSerial(params, sessionVo);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/clearSerialNo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> clearSerialNo(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		int totCnt = serialMgmtNewService.clearSerialNo(params, sessionVO);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

}
