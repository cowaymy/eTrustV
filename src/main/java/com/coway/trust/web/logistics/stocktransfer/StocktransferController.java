/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.stocktransfer;

import java.util.ArrayList;
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
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.logistics.organization.MaintainMovementService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/stocktransfer")
public class StocktransferController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "stocktranService")
	private StockTransferService stock;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	

	@RequestMapping(value = "/StocktransferIns.do")
	public String stockins(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/StockTrans/StockTransferIns";
	}
	
	@RequestMapping(value = "/StockTransferDeliveryList.do")
	public String stockTransferDeliveryList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/StockTrans/StockTransferDeliveryList";
	}
	
	@RequestMapping(value = "/StocktransferList.do")
	public String stocklist(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String streq     = request.getParameter("streq");
		String sttype    = request.getParameter("sttype");
		String smtype    = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt    = request.getParameter("crtsdt");
		String crtedt    = request.getParameter("crtedt");
		String reqsdt    = request.getParameter("reqsdt");
		String reqedt    = request.getParameter("reqedt");
		String sam       = request.getParameter("sam");
		String sstatus   = request.getParameter("sstatus");
		String rStcode   = request.getParameter("rStcode");
		
		Map<String, Object> map = new HashMap();
		map.put("streq"    , streq    );
		map.put("sttype"   , sttype   );
		map.put("smtype"   , smtype   );
		map.put("tlocation", tlocation);
		map.put("flocation", flocation);
		map.put("crtsdt"   , crtsdt   );
		map.put("crtedt"   , crtedt   );
		map.put("reqsdt"   , reqsdt   );
		map.put("reqedt"   , reqedt   );
		map.put("sam"      , sam      );
		map.put("sstatus"  , sstatus  );
		
		model.addAttribute("searchVal", map);
		
		return "logistics/StockTrans/StockTransferList";
	}
	
	@RequestMapping(value = "/StocktransferListDelivery.do")
	public String stocklistdelivery(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String streq     = request.getParameter("streq");
		String sttype    = request.getParameter("sttype");
		String smtype    = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt    = request.getParameter("crtsdt");
		String crtedt    = request.getParameter("crtedt");
		String reqsdt    = request.getParameter("reqsdt");
		String reqedt    = request.getParameter("reqedt");
		String sam       = request.getParameter("sam");
		String sstatus   = request.getParameter("sstatus");
		String rStcode   = request.getParameter("rStcode");
		
		Map<String, Object> map = new HashMap();
		map.put("streq"    , streq    );
		map.put("sttype"   , sttype   );
		map.put("smtype"   , smtype   );
		map.put("tlocation", tlocation);
		map.put("flocation", flocation);
		map.put("crtsdt"   , crtsdt   );
		map.put("crtedt"   , crtedt   );
		map.put("reqsdt"   , reqsdt   );
		map.put("reqedt"   , reqedt   );
		map.put("sam"      , sam      );
		map.put("sstatus"  , sstatus  );
		model.addAttribute("searchVal", map);
		
		return "logistics/StockTrans/StockTransferListDelivery";
	}
	
	@RequestMapping(value = "/StocktransferView.do" , method = RequestMethod.POST)
	public String stockview(Model model, HttpServletRequest request, HttpServletResponse response ) throws Exception {
		String streq     = request.getParameter("streq");
		String sttype    = request.getParameter("sttype");
		String smtype    = request.getParameter("smtype");
		String tlocation = request.getParameter("tlocation");
		String flocation = request.getParameter("flocation");
		String crtsdt    = request.getParameter("crtsdt");
		String crtedt    = request.getParameter("crtedt");
		String reqsdt    = request.getParameter("reqsdt");
		String reqedt    = request.getParameter("reqedt");
		String sam       = request.getParameter("sam");
		String sstatus   = request.getParameter("sstatus");
		String rStcode   = request.getParameter("rStcode");
		
		Map<String, Object> map = new HashMap();
		map.put("streq"    , streq    );
		map.put("sttype"   , sttype   );
		map.put("smtype"   , smtype   );
		map.put("tlocation", tlocation);
		map.put("flocation", flocation);
		map.put("crtsdt"   , crtsdt   );
		map.put("crtedt"   , crtedt   );
		map.put("reqsdt"   , reqsdt   );
		map.put("reqedt"   , reqedt   );
		map.put("sam"      , sam      );
		map.put("sstatus"  , sstatus  );
		
		model.addAttribute("searchVal", map);
		model.addAttribute("rStcode", rStcode);
		
		return "logistics/StockTrans/StockTransferView";
	}

	@RequestMapping(value = "/StocktransferSearchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationList(@RequestBody Map<String, Object> params, Model model) throws Exception {
		
		List<EgovMap> list = stock.selectStockTransferMainList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/StocktransferRequestDeliveryList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> StocktransferRequestDeliveryList(@RequestParam Map<String, Object> params , Model model) throws Exception {
		
		
		List<EgovMap> list = stock.selectStockTransferDeliveryList(params);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/StocktransferAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferAdd(@RequestBody Map<String, Object> params,
			Model model) {

		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD); 
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		
		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("form", formMap);
		param.put("userId", 999999999);
		stock.insertStockTransferInfo(param);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/StocktransferReqAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferReqAdd(@RequestBody Map<String, Object> params,
			Model model) {

		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD); 
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		
		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("upd", updList);
		param.put("form", formMap);
		param.put("userId", 999999999);
		
		stock.addStockTransferInfo(param);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectStockTransferNo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		logger.debug("groupCode : {}", params.get("groupCode"));
		
		List<EgovMap> codeList = stock.selectStockTransferNoList(params);
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/StocktransferDataDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map> StocktransferDataDetail( Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String rstonumber = request.getParameter("rStcode");
		
		Map<String, Object> map = stock.StocktransferDataDetail(rstonumber);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/stockTransferItemDeliveryQty.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockTransferItemDeliveryQty( Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String toloc = request.getParameter("toloc");
		String itmcd = request.getParameter("itmcd");
		int iCnt = 0;
		Map<String, Object> map = new HashMap();
		map.put("toloc", toloc);
		map.put("itmcd", itmcd);
		
		iCnt = (int)stock.stockTransferItemDeliveryQty(map);
		
		map.put("iqty", iCnt);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/stockTransferTolocationItemList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockTransferTolocationItemList( Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String[] type = request.getParameterValues("cType");
		String toloc = request.getParameter("slocation");
		
		
		Map<String, Object> smap = new HashMap();
		smap.put("ctype", type);
		smap.put("toloc", toloc);
		
		List<EgovMap> list = stock.selectTolocationItemList(smap);
		
		smap.put("data", list);

		return ResponseEntity.ok(smap);
	}
	@RequestMapping(value = "/StocktransferDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferDelivery(@RequestBody Map<String, Object> params,
			Model model) {

		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//Map<String , Object> formMap = (Map<String, Object>) formList.get(0);
		
		Map<String, Object> param = new HashMap();
		param.put("upd", updList);
		param.put("form", formMap);
		param.put("userId", 999999999);
		
		stock.deliveryStockTransferInfo(param);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/StocktransferReqItemDelete.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferReqItemDelete(@RequestBody Map<String, Object> params,
			Model model) {

		List<Object> delList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//Map<String , Object> formMap = (Map<String, Object>) formList.get(0);
		
		Map<String, Object> param = new HashMap();
		param.put("del", delList);
		param.put("form", formMap);
		param.put("userId", 999999999);
		
		stock.deliveryStockTransferItmDel(param);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/StocktransferReqDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> StocktransferReqDelivery(@RequestBody Map<String, Object> params,
			Model model) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		
		
		Map<String, Object> param = new HashMap();
		param.put("check", list);
		param.put("userId", 999999999);
		
		stock.StocktransferReqDelivery(param);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/StocktransferSearchDeliveryList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> StocktransferSearchDeliveryList(@RequestBody Map<String, Object> params, Model model) throws Exception {
		
		
		List<EgovMap> list = stock.selectStockTransferDeliveryList(params);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
}
