package com.coway.trust.web.logistics.purchase;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.purchase.PurchasePriceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/purchase")
public class PurchasePriceController {
	private final Logger Logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "purchasPriceService")
	private PurchasePriceService purchasPriceService;

	@RequestMapping(value = "/purchasePrice.do")
	public String purchasePrice(@RequestParam Map<String, Object> params) {
		return "logistics/purchase/purchasePrice";
	}

	@RequestMapping(value = "/purchasePriceList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> purchasePriceList(Model model, HttpServletRequest request, HttpServletResponse response,
			SessionVO sessionVO) throws Exception {
		
		String[] msttype = request.getParameterValues("msttype");
		String vendercd = request.getParameter("vendercd");
		String mstcd = request.getParameter("mstcd");
		String purchasorg = request.getParameter("purchasorg");
		String excludedelete = request.getParameter("excludedelete");
		
//		Logger.debug("msttype    값 : {}", msttype);
//		Logger.debug("vendercd    값 : {}", vendercd);
//		Logger.debug("mstcd    값 : {}", mstcd);
//		Logger.debug("purchasorg    값 : {}", purchasorg);
//		Logger.debug("excludedelete    값 : {}", excludedelete);
		
		Map<String, Object> smap = new HashMap();
		smap.put("msttype", msttype);
		smap.put("vendercd", vendercd);
		smap.put("mstcd", mstcd);
		smap.put("purchasorg", purchasorg);
		smap.put("excludedelete", excludedelete);
		
		List<EgovMap> list = purchasPriceService.purchasePriceList(smap);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/purchasePriceHistoryList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> purchasePriceHistoryList(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		List<EgovMap> list = purchasPriceService.purchasePriceList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

}
