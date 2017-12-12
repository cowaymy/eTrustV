package com.coway.trust.web.logistics.pos;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
import com.coway.trust.biz.logistics.pointofsales.PointOfSalesService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/pos")
public class PointOfSalesController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "PointOfSalesService")
	private PointOfSalesService PointOfSalesService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/PointOfSalesList.do")
	public String poslist(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String reqno = request.getParameter("reqno");
		String reqtype = request.getParameter("reqtype");
		String reqloc = request.getParameter("reqloc");
		
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
			
		
		Map<String, Object> map = new HashMap();
		map.put("reqno", reqno);
		map.put("reqtype", reqtype);
		map.put("reqloc", reqloc);
		map.put("today", today);

		model.addAttribute("searchVal", map);

		return "logistics/Pos/PointOfSalesList";
	}

	@RequestMapping(value = "/PosOfSalesIns.do")
	public String posins(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Pos/PointOfSalesIns";
	}

	@RequestMapping(value = "/PosView.do", method = RequestMethod.POST)
	public String PosView(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
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

		return "logistics/Pos/PointOfSalesView";
	}

	@RequestMapping(value = "/SearchSessionInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map> SearchSessionInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String UserName;
		String UserCode;
		int UserBranchId;
		if (sessionVO == null) {
			UserName = "ham";
		} else {
			UserName = sessionVO.getUserName();
		}
		if (sessionVO == null) {
			UserBranchId = 4;
			UserCode = "T010";
		} else {
			UserBranchId = sessionVO.getUserBranchId();
			UserCode = "T010";
		}

//		logger.debug("UserName    값 : {}", UserName);
//		logger.debug("UserCode    값 : {}", UserCode);
//		logger.debug("UserBranchId    값 : {}", UserBranchId);

		Map<String, Object> map = new HashMap();
		map.put("UserName", UserName);
		map.put("UserCode", UserCode);
		map.put("UserBranchId", UserBranchId);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/PosSearchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> PosSearchList(@RequestBody Map<String, Object> params, Model model) throws Exception {

//		logger.debug("searchOthersReq1    값 : {}", params.get("searchOthersReq1"));
//		logger.debug("searchOthersReq2    값 : {}", params.get("searchOthersReq2"));
//		logger.debug("searchReqType    값 : {}", params.get("searchReqType"));
//		/*logger.debug("searchLoc    값 : {}", params.get("searchLoc"));*/
//		logger.debug("tlocation    값 : {}", params.get("tlocation"));
//		logger.debug("searchStatus    값 : {}", params.get("searchStatus"));
//		logger.debug("crtsdt    값 : {}", params.get("crtsdt"));
//		logger.debug("crtedt    값 : {}", params.get("crtedt"));
//		logger.debug("reqsdt    값 : {}", params.get("reqsdt"));
//		logger.debug("reqedt    값 : {}", params.get("reqedt"));

		String Status = (String) params.get("searchStatus");
		params.put("searchStatus", Status);
		String crtsdt = (String) params.get("crtsdt");
		crtsdt = crtsdt.replace("/", "");
		String crtedt = (String) params.get("crtedt");
		crtedt = crtedt.replace("/", "");
		String reqsdt = (String) params.get("reqsdt");
		reqsdt = reqsdt.replace("/", "");
		String reqedt = (String) params.get("reqedt");
		reqedt = reqedt.replace("/", "");
		params.put("crtsdt", crtsdt);
		params.put("crtedt", crtedt);
		params.put("reqsdt", reqsdt);
		params.put("reqedt", reqedt);

		List<EgovMap> list = PointOfSalesService.PosSearchList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/PosItemList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> PosItemList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String[] PosItemType = request.getParameterValues("PosItemType");
		String[] catetype = request.getParameterValues("catetype");
		String reqLoc = request.getParameter("reqLoc");
		String mcode = request.getParameter("materialCode");

//		logger.debug("reqLoc    값 : {}", reqLoc);

		// for (int i = 0; i < PosItemType.length; i++) {
		// logger.debug("PosItemType 값 : {}", PosItemType[i]);
		// }

		Map<String, Object> smap = new HashMap();
		smap.put("ctype", PosItemType);
		smap.put("catetype", catetype);
		smap.put("reqLoc", reqLoc);
		smap.put("mcode",  mcode);

		List<EgovMap> list = PointOfSalesService.posItemList(smap);

		smap.put("data", list);

		return ResponseEntity.ok(smap);
	}
	
	@RequestMapping(value = "/selectTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTypeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> list = PointOfSalesService.selectTypeList(params);
	
		System.out.println(":::"+list);
		return ResponseEntity.ok(list);
		
	}

	@RequestMapping(value = "/PointOfSalesSerialCheck.do", method = RequestMethod.GET)
	public ResponseEntity<Map> PointOfSalesSerialCheck(@RequestParam Map<String, Object> params) {

		// logger.debug("serial : {}", params.get("serial"));

		List<EgovMap> list = PointOfSalesService.selectPointOfSalesSerial(params);
		Map<String, Object> rmap = new HashMap();
		
		for (int i = 0; i < list.size(); i++) {
			logger.debug("serialList@: {}", list.get(i));
		}
		
		rmap.put("data", list);
		return ResponseEntity.ok(rmap);
	}

	@RequestMapping(value = "/insertPosInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertPosInfo(@RequestBody Map<String, Object> params, Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);

		String posSeq = PointOfSalesService.insertPosInfo(params);

		Map<String, Object> rmap = new HashMap();
		rmap.put("data", posSeq);

		// logger.debug("posSeq@@@@@: {}", posSeq);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(posSeq);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/PosGiSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> PosGiSave(@RequestBody Map<String, Object> params, Model model) {

//		List<Object> GIList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
//		Map<String, Object> GIMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("userId", loginId);
		String reVal = PointOfSalesService.insertGiInfo(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(reVal);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/PosDataDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map> StocktransferDataDetail(Model model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String rstonumber = request.getParameter("rStcode");
		Map<String, Object> map = PointOfSalesService.PosDataDetail(rstonumber);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/ViewSerial.do", method = RequestMethod.GET)
	public ResponseEntity<Map> ViewSerial(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String reqno = request.getParameter("reqno");
		String itmcd = request.getParameter("itmcd");
//		logger.debug("reqno@@@@@: {}", reqno);
//		logger.debug("itmcd@@@@@: {}", itmcd);

		Map<String, Object> serialmap = new HashMap();
		serialmap.put("reqno", reqno);
		serialmap.put("itmcd", itmcd);

		List<EgovMap> list = PointOfSalesService.selectSerial(serialmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/MaterialDocumentList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectStockMovementRequestDeliveryList(@RequestParam Map<String, Object> params,
			Model model) throws Exception {

//		logger.debug("reqstno@@@@@: {}", params.get("reqstno"));

		List<EgovMap> mtrList = PointOfSalesService.selectMaterialDocList(params);

//		for (int i = 0; i < mtrList.size(); i++) {
//			logger.debug("MaterialDocumentList@@@@@: {}", mtrList.get(i));
//		}

		Map<String, Object> map = new HashMap();

		map.put("data2", mtrList);

		return ResponseEntity.ok(map);
	}

}
