
package com.coway.trust.web.logistics.stocks;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.stocks.StockService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/stock")
public class StockListController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "stockService")
	private StockService stock;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/Stock.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Stock/StockList";
	}

	@RequestMapping(value = "/StockList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectStockList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String[] cate = request.getParameterValues("cmbCategory");
		String[] type = request.getParameterValues("cmbType");
		String[] status = request.getParameterValues("cmbStatus");
		String stkNm = request.getParameter("stkNm");
		String stkCd = request.getParameter("stkCd");

		String oldstkcd = request.getParameter("oldstkcd");

		Map<String, Object> smap = new HashMap();
		smap.put("cateList", cate);
		smap.put("typeList", type);
		smap.put("statList", status);
		smap.put("stkNm", stkNm);
		smap.put("stkCd", stkCd);
		smap.put("oldstkcd", oldstkcd);

		List<EgovMap> list = stock.selectStockList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StockInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockInfo(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String stkid = request.getParameter("stkid");
		String mode = CommonUtils.nvl(request.getParameter("mode"));

		Map<String, Object> smap = new HashMap();
		smap.put("stockId", stkid);
		smap.put("mode", mode);

		List<EgovMap> info = stock.selectStockInfo(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/PriceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectPriceInfo(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String stkid = CommonUtils.nvl(request.getParameter("stkid"));
		String typeid = CommonUtils.nvl(request.getParameter("typeid"));
		String srvpacid = CommonUtils.nvl(request.getParameter("srvpacid"));
		String appTypeId = CommonUtils.nvl(request.getParameter("appTypeId"));

		Map<String, Object> smap = new HashMap();
		smap.put("stockId", stkid);
		smap.put("typeId", typeid);
		smap.put("srvpacid", srvpacid);
		smap.put("appTypeId", appTypeId);

		if(!"".equals(String.valueOf(srvpacid)) && srvpacid!=null){
			smap.put("srvPackageId", srvpacid);
		}
		else{
			smap.put("srvPackageId", "0");
		}

		if(!"".equals(appTypeId) && appTypeId!=null){
			stock.updateStockPriceInfo(smap);
		}


		List<EgovMap> info = stock.selectPriceInfo(smap);
		List<EgovMap> infoHistory = stock.selectPriceHistoryInfo(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		map.put("data2", infoHistory);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/FilterInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectFilterInfo(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String stkid = CommonUtils.nvl(request.getParameter("stkid"));
		String grid = CommonUtils.nvl(request.getParameter("grid"));

		Map<String, Object> smap = new HashMap();
		smap.put("stockId", stkid);
		smap.put("grid", grid);

		List<EgovMap> info = stock.selectFilterInfo(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/ServiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectServiceInfo(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String stkid = CommonUtils.nvl(request.getParameter("stkid"));

		Map<String, Object> smap = new HashMap();
		smap.put("stockId", stkid);

		List<EgovMap> info = stock.selectServiceInfo(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectStockImgList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockImgList(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String stkid = CommonUtils.nvl(request.getParameter("stkid"));

		Map<String, Object> smap = new HashMap();
		smap.put("stockId", stkid);

		List<EgovMap> imglist = stock.selectStockImgList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", imglist);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/modifyStockInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> modifyStockInfo(@RequestBody Map<String, Object> params, Model model) throws Exception {
		// sampleService.saveTransaction(params);
		String retMsg = AppConstants.MSG_SUCCESS;

		// loginId
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		params.put("upd_user", loginId);

		Map<String, Object> map = new HashMap();
		map.put("revalue", params.get("revalue"));
		map.put("stkid", params.get("stockId"));

		try {
			stock.updateStockInfo(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/modifyPriceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> modifyPriceInfo(@RequestBody Map<String, Object> params, Model model) throws Exception {

		// sampleService.saveTransaction(params);
		String retMsg = "Price update successfully requested!";
		String retMsg2 = "There are price request pending for approval";

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		// loginId
		params.put("upd_user", loginId);

		Map<String, Object> map = new HashMap();
		map.put("revalue", params.get("revalue"));
		map.put("stkid", params.get("stockId"));
		map.put("appTypeId", params.get("appTypeId"));

//		stock.updateStockPriceInfo(params);
//		stock.updatePriceInfo2(params);

		int cnt = stock.countInPrgrsPrcApproval(params);

		if (cnt < 1){
			stock.insertSalePriceReqst(params);
			map.put("msg", retMsg);
		}

		else {
			map.put("msg", retMsg2);
		}


//		stock.updatePriceInfo(params);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/confirmPriceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map> confirmPriceInfo(@RequestBody Map<String, Object> params, Model model) throws Exception {

		String rtnMsg = "";
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		// loginId
		params.put("upd_user", loginId);

		Map<String, Object> map = new HashMap();
		map.put("revalue", params.get("revalue"));
		map.put("stkid", params.get("stkId"));
		map.put("appTypeId", params.get("appTypeId"));

		stock.updatePriceReqstApproval(params);
		if(params.get("appvStatus").equals("5")){
				stock.updateStockPriceInfo(params);
				stock.updatePriceInfo2(params);
				rtnMsg = "Price request has been successfully approved";
		}

		else{
			rtnMsg = "Price request has been successfully rejected";
		}

		map.put("msg", rtnMsg);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/srvMembershipList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> srvMembershipList(Map<String, Object> params) {

		// 조회.
		List<EgovMap> srvMembershipList = stock.srvMembershipList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(srvMembershipList);
	}

	/**
	 *
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/modifyServiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> modifyServiceInfo(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		int stockId = (int) params.get("stockId");
		List<Object> removeLIst = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		List<Object> addLIst = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		// logger.debug("수정 : {}", addLIst.toString());
		// logger.debug("delete : {}", removeLIst.toString());
		logger.debug("stockId id : {}", params.get("stockId"));

		int cnt = 0;

		if (!removeLIst.isEmpty()) {
			if (removeLIst.size() > 0) {
				cnt = stock.removeServiceInfoGrid(stockId, removeLIst, loginId);
			}

		} else if (!addLIst.isEmpty()) {
			if (addLIst.size() > 0) {
				cnt = stock.addServiceInfoGrid(stockId, addLIst, loginId);
			}
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/modifyServicePoint.do", method = RequestMethod.POST)
	public ResponseEntity<Map> modifyServicePoint(@RequestBody Map<String, Object> params, Model model) {

		String retMsg = AppConstants.MSG_SUCCESS;

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		int stockId = (int) params.get("stockId");

		logger.debug("stockId id : {}", params);
		params.put("userid", loginId);

		Map<String, Object> map = new HashMap();
		map.put("revalue", params.get("revalue"));
		map.put("stkid", params.get("stockId"));

		try {
			stock.modifyServicePoint(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);

	}

	@SuppressWarnings({ "unchecked", "unused", "null" })
	@RequestMapping(value = "/modifyFilterInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> modifyFilterInfo(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		int stockId = (int) params.get("stockId");
		String revalue = (String) params.get("revalue");
		List<Object> removeLIst = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		List<Object> addLIst = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		logger.info("removeLIst : {}", removeLIst.size());
		// logger.info("addLIst : {}", addLIst.size());
		int cnt = 0;

		// if(!removeLIst.isEmpty()){
		if (null != removeLIst || !"".equals(removeLIst)) {
			// if(removeLIst.size() > 0){
			cnt = stock.removeFilterInfoGrid(stockId, removeLIst, loginId, revalue);
			// }

		}
		// if (!addLIst.isEmpty()) {
		if (null != addLIst || !"".equals(addLIst)) {
			// if(addLIst.size() > 0){
			cnt = stock.addFilterInfoGrid(stockId, addLIst, loginId, revalue);
			// }
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/StockCommisionSetting.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockCommisionSetting(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String stkid = request.getParameter("stkid");
		// String mode = CommonUtils.nvl(request.getParameter("mode"));

		Map<String, Object> param = new HashMap();
		param.put("stockId", stkid);
		// smap.put("mode", mode);

		List<EgovMap> info = stock.selectStockCommisionSetting(param);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/StockCommisionUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> modifyStockCommision(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		// int stockId = (int) params.get("stockId");
		// List<Object> removeLIst = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		// List<Object> addLIst = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		// logger.debug("수정 : {}", addLIst.toString());
		// logger.debug("delete : {}", removeLIst.toString());
		// logger.debug("stockId id : {}", params.get("stockId"));

		/*
		 * //int cnt = 0;
		 *
		 * //if (!removeLIst.isEmpty()) { if (removeLIst.size() > 0) { cnt = stock.removeServiceInfoGrid(stockId,
		 * removeLIst, loginId); }
		 *
		 * } else if (!addLIst.isEmpty()) { if (addLIst.size() > 0) { cnt = stock.addServiceInfoGrid(stockId, addLIst,
		 * loginId); } }
		 */
		stock.updateStockCommision(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/nonvalueStockIns.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> nonvalueStockIns(@RequestBody Map<String, Object> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		String reVal = stock.nonvalueStockIns(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(reVal);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/nonvaluedItemCodeChk.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> nonvaluedItemCodeChk(@RequestParam Map<String, Object> params) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		EgovMap result = stock.nonvaluedItemCodeChk(params);

		return ResponseEntity.ok(result);
	}


	 @RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCodeList() {

	    List<EgovMap> codeList = stock.selectCodeList();

	    return ResponseEntity.ok(codeList);
	  }

	 @RequestMapping(value = "/EosEomInfo.do", method = RequestMethod.POST)
		public ResponseEntity<Map> getEosEomInfo(ModelMap model, HttpServletRequest request, HttpServletResponse response)
				throws Exception {
			String stkid = request.getParameter("stkid");
			String mode = CommonUtils.nvl(request.getParameter("mode"));

			Map<String, Object> smap = new HashMap();
			smap.put("stockId", stkid);
			smap.put("mode", mode);

			List<EgovMap> info = stock.getEosEomInfo(smap);

			Map<String, Object> map = new HashMap();
			map.put("data", info);
			return ResponseEntity.ok(map);
		}

      @RequestMapping(value = "/modifyEosEomInfo.do", method = RequestMethod.POST)
      public ResponseEntity<Map> modifyEosEomInfo(@RequestBody Map<String, Object> params, Model model) throws Exception {
			String retMsg = AppConstants.MSG_SUCCESS;

			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			int loginId;
			if (sessionVO == null) {
				loginId = 99999999;
			} else {
				loginId = sessionVO.getUserId();
			}

			// loginId
			params.put("upd_user", loginId);

			Map<String, Object> map = new HashMap();
			map.put("stkid", params.get("stockId"));
			map.put("msg", retMsg);

			stock.modifyEosEomInfo(params);

			return ResponseEntity.ok(map);
	  }

      @RequestMapping(value = "/editPriceInfo.do", method = RequestMethod.GET)
  	public ResponseEntity<Map> selectEditPriceInfo(ModelMap model, HttpServletRequest request, HttpServletResponse response)
  			throws Exception {
  		String stkid = CommonUtils.nvl(request.getParameter("stkid"));
  		String typeid = CommonUtils.nvl(request.getParameter("typeId"));
  		String srvpacid = CommonUtils.nvl(request.getParameter("srvpacid"));
  		String appTypeId = CommonUtils.nvl(request.getParameter("appTypeId"));

  		logger.debug("typeId: " + typeid);
  		Map<String, Object> smap = new HashMap();
  		smap.put("stockId", stkid);
  		smap.put("typeId", typeid);
  		smap.put("srvpacid", srvpacid);
  		smap.put("appTypeId", appTypeId);

  		if(!"".equals(String.valueOf(srvpacid)) && srvpacid!=null){
  			smap.put("srvPackageId", srvpacid);
  		}
  		else{
  			smap.put("srvPackageId", "0");
  		}

  		if(!"".equals(appTypeId) && appTypeId!=null){
			stock.updateStockPriceInfo(smap);
		}

  		List<EgovMap> info = stock.selectPriceInfo2(smap);
  		logger.debug("Info >>> " + info);
  		List<EgovMap> infoHistory = stock.selectPriceHistoryInfo2(smap);

  		Map<String, Object> map = new HashMap();
  		map.put("data", info);
  		map.put("data2", infoHistory);

  		return ResponseEntity.ok(map);
  	}


      @RequestMapping(value = "/selectCodeList2.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCodeList2() {

	    List<EgovMap> codeList = stock.selectCodeList2();

	    return ResponseEntity.ok(codeList);
	  }


}
