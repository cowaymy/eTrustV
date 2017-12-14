package com.coway.trust.web.logistics.assetmaster;

import java.text.SimpleDateFormat;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.asset.AssetMngService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/assetmng")
public class AssetMasterController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "AssetMngService")
	private AssetMngService ams;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/AssetMaster.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/AssetMng/assetList";
	}

	@RequestMapping(value = "/assetList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> assetList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// logger.debug("searchassetid 값 : {}", request.getParameter("searchassetid"));
		 logger.debug("searchstatus 값 : {}", request.getParameterValues("searchstatus"));
		 logger.debug("searchbrand 값 : {}", request.getParameter("searchbrand"));
		 logger.debug("searchcategory 값 : {}", request.getParameter("searchcategory"));
		 logger.debug("searchtype 값 : {}", request.getParameterValues("searchtype"));
		// logger.debug("searchcolor 값 : {}", request.getParameter("searchcolor"));
		// logger.debug("searchmodelname 값 : {}", request.getParameter("searchmodelname"));
		// logger.debug("searchpurchasedate1 값 : {}", request.getParameter("searchpurchasedate1"));
		// logger.debug("searchpurchasedate2 값 : {}", request.getParameter("searchpurchasedate2"));
		// logger.debug("searchrefno 값 : {}", request.getParameter("searchrefno"));
		// logger.debug("searchbranchid 값 : {}", request.getParameter("searchbranchid"));
		// logger.debug("searchdepartment 값 : {}", request.getParameterValues("searchdepartment"));
		// logger.debug("searchinvoiceno 값 : {}", request.getParameter("searchinvoiceno"));
		// logger.debug("searchdealer 값 : {}", request.getParameter("searchdealer"));
		// logger.debug("searchserialno 값 : {}", request.getParameter("searchserialno"));
		// logger.debug("searchwarrantyno 값 : {}", request.getParameter("searchwarrantyno"));
		// logger.debug("searchimeino 값 : {}", request.getParameter("searchimeino"));
		// logger.debug("searchmacaddress 값 : {}", request.getParameter("searchmacaddress"));
		// logger.debug("searchcreator 값 : {}", request.getParameter("searchcreator"));
		// logger.debug("searchcreatedate1 값 : {}", request.getParameter("searchcreatedate1"));
		// logger.debug("searchcreatedate2 값 : {}", request.getParameter("searchcreatedate2"));

		String searchassetid = request.getParameter("searchassetid");
		String[] searchstatus = request.getParameterValues("searchstatus");
		String[] searchtype = request.getParameterValues("searchtype");
		String[] searchdepartment = request.getParameterValues("searchdepartment");
		String searchbrand = request.getParameter("searchbrand");
		String searchcolor = request.getParameter("searchcolor");
		String searchmodelname = request.getParameter("searchmodelname");
		String searchpurchasedate1 = request.getParameter("searchpurchasedate1");
		String searchpurchasedate2 = request.getParameter("searchpurchasedate2");
		String searchrefno = request.getParameter("searchrefno");
		String searchbranchid = request.getParameter("searchbranchid");
		String searchinvoiceno = request.getParameter("searchinvoiceno");
		String searchdealer = request.getParameter("searchdealer");
		String searchserialno = request.getParameter("searchserialno");
		String searchwarrantyno = request.getParameter("searchwarrantyno");
		String searchimeino = request.getParameter("searchimeino");
		String searchmacaddress = request.getParameter("searchmacaddress");
		String searchcreator = request.getParameter("searchcreator");
		String searchcreatedate1 = request.getParameter("searchcreatedate1");
		String searchcreatedate2 = request.getParameter("searchcreatedate2");

		Map<String, Object> assetmap = new HashMap();
		assetmap.put("searchassetid", searchassetid);
		assetmap.put("searchstatus", searchstatus);
		assetmap.put("searchtype", searchtype);
		assetmap.put("searchdepartment", searchdepartment);
		assetmap.put("searchbrand", searchbrand);
		assetmap.put("searchcolor", searchcolor);
		assetmap.put("searchmodelname", searchmodelname);
		assetmap.put("searchpurchasedate1", searchpurchasedate1);
		assetmap.put("searchpurchasedate2", searchpurchasedate2);
		assetmap.put("searchrefno", searchrefno);
		assetmap.put("searchbranchid", searchbranchid);
		assetmap.put("searchinvoiceno", searchinvoiceno);
		assetmap.put("searchdealer", searchdealer);
		assetmap.put("searchserialno", searchserialno);
		assetmap.put("searchwarrantyno", searchwarrantyno);
		assetmap.put("searchimeino", searchimeino);
		assetmap.put("searchmacaddress", searchmacaddress);
		assetmap.put("searchcreator", searchcreator);
		assetmap.put("searchcreatedate1", searchcreatedate1);
		assetmap.put("searchcreatedate2", searchcreatedate2);

		List<EgovMap> list = ams.selectAssetList(assetmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectDetailList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectDetailList(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String assetid = request.getParameter("assetid");
		// logger.debug("assetid 키값 : {}", assetid);

		Map<String, Object> assetdetailmap = new HashMap();
		assetdetailmap.put("assetid", assetid);

		List<EgovMap> list = ams.selectDetailList(assetdetailmap);
		/*
		 * logger.debug("디테일 리스트!!!!!!!!!!!!! : {}", list.size()); for (int i = 0; i < list.size(); i++) { logger.debug(
		 * "디테일 리스트!!!!!!!!!!!!! : {}", list.get(i)); }
		 */

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectDealerList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDealerList(@RequestParam Map<String, Object> params) {

		logger.debug("selectDealerListCode : {}", params.get("groupCode"));

		List<EgovMap> DealerList = ams.selectDealerList(params);

		return ResponseEntity.ok(DealerList);
	}

	@RequestMapping(value = "/selectBrandList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBrandList(@RequestParam Map<String, Object> params) {

		logger.debug("selectBrandListCode : {}", params.get("groupCode"));

		List<EgovMap> BrandList = ams.selectBrandList(params);
		for (int i = 0; i < BrandList.size(); i++) {
			logger.debug("%%%%%%%%BrandList%%%%%%%: {}", BrandList.get(i));
		}

		return ResponseEntity.ok(BrandList);
	}

	@RequestMapping(value = "/selectTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTypeList(@RequestParam Map<String, Object> params) {

		params.put("hrchytypeid", "1198");

		List<EgovMap> TypeList = ams.selectTypeList(params);
		/*
		 * for (int i = 0; i < TypeList.size(); i++) { logger.debug("%%%%%%%%TypeList%%%%%%%: {}", TypeList.get(i)); }
		 */
		return ResponseEntity.ok(TypeList);
	}

	@RequestMapping(value = "/selectDepartmentList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDepartmentList(@RequestParam Map<String, Object> params) {

		List<EgovMap> DepartmentList = ams.selectDepartmentList(params);
		// for (int i = 0; i < DepartmentList.size(); i++) {
		// logger.debug("%%%%%%%%DepartmentList%%%%%%%: {}", DepartmentList.get(i));
		// }

		return ResponseEntity.ok(DepartmentList);
	}

	@RequestMapping(value = "/insertAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertAssetMng(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

		Map<String, Object> masterMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		logger.debug("mastertype  : {}", masterMap.get("mastertype"));
		logger.debug("mastercategory  : {}", masterMap.get("mastercategory"));
		logger.debug("mastermodelname  : {}", masterMap.get("mastermodelname"));
		logger.debug("masterinvoiceno  : {}", masterMap.get("masterinvoiceno"));
		logger.debug("masterdealer  : {}", masterMap.get("masterdealer"));
		logger.debug("masterbrand  : {}", masterMap.get("masterbrand"));
		logger.debug("masterpurchaseamount  : {}", masterMap.get("masterpurchaseamount"));
		logger.debug("masterrefno  : {}", masterMap.get("masterrefno"));
		logger.debug("masterserialno  : {}", masterMap.get("masterserialno"));
		logger.debug("masterwarrantyno  : {}", masterMap.get("masterwarrantyno"));
		logger.debug("mastermacaddress  : {}", masterMap.get("mastermacaddress"));
		logger.debug("masterremark  : {}", masterMap.get("masterremark"));

		List<EgovMap> detailAddList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		for (int i = 0; i < detailAddList.size(); i++) {
			logger.debug("%%%%%%%%detailAddList%%%%%%%: {}", detailAddList.get(i));
		}

		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		try {
			ams.insertAssetMng(masterMap, detailAddList, loginId);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/motifyAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> motifyAssetMng(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

//		params.put("masterpurchasedate", CommonUtils.changeFormat((String) params.get("masterpurchasedate"),
//				SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;

		// loginId
		params.put("upd_user_id", loginId);

		Map<String, Object> map = new HashMap();

		try {
			ams.motifyAssetMng(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/deleteAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> deleteAssetMng(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();
		
		logger.debug("masterassetid  : {}", params.get("masterassetid"));

		try {
			 ams.deleteAssetMng(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/addItemAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> addItemAssetMng(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

		// logger.debug("아이템 추가 통과" );

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		List<EgovMap> itemAddList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		for (int i = 0; i < itemAddList.size(); i++) {
			// itemAddList.get(i).put("loginId", loginId);
			// logger.debug("%%%%%@@@@@@@@@@@@@%%%itemAddList%%%%%%%: {}", itemAddList.get(i));
		}

		String retMsg = AppConstants.MSG_SUCCESS;
		Map<String, Object> map = new HashMap();

		try {
			ams.addItemAssetMng(itemAddList, loginId);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/updateItemAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateItemAssetMng(@RequestBody Map<String, Object> params,
			ModelMap mode) throws Exception {

		// logger.debug("업데이트 아이템 통과!!!!!!!!!!!!!!!!!!!!!!!!!!!" );

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
		for (int i = 0; i < updateItemList.size(); i++) {
			 logger.debug("%%%%%%%%updateItemList%%%%%%%: {}", updateItemList.get(i));
		}
		List<EgovMap> ItemAddList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		for (int i = 0; i < ItemAddList.size(); i++) {
			 logger.debug("@@@@@@@ItemAddList@@@@@: {}", ItemAddList.get(i));
		}

		// logger.debug("addassetid : {}", params.get("addassetid"));
		// logger.debug("additemtype : {}", params.get("additemtype"));
		// logger.debug("additemBrand : {}", params.get("additemBrand"));
		// logger.debug("additemmodel : {}", params.get("additemmodel"));
		// logger.debug("addremark : {}", params.get("addremark"));
		// logger.debug("additemname : {}", params.get("additemname"));
		// logger.debug("additemvalue : {}", params.get("additemvalue"));
		// logger.debug("additemremark : {}", params.get("additemremark"));

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		try {
			ams.updateItemAssetMng(params, loginId);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/RemoveItemAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> RemoveItemAssetMng(@RequestBody Map<String, Object> params,
			ModelMap mode) throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}
		params.put("upd_user_id", loginId);

		logger.debug("multyassetid  : {}", params.get("multyassetid"));
		logger.debug("itemassetdid  : {}", params.get("itemassetdid"));

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		try {
			ams.RemoveItemAssetMng(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/copyAsset.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertCopyAsset(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		int cnt = 0;
		int assetid = Integer.parseInt(request.getParameter("assetid"));
		int copyquantity = Integer.parseInt(request.getParameter("copyquantity"));

		// Map<String, Object> params = new HashMap();
		Map<String, Object> map = new HashMap();
		// params.put("categoryid", assetid);
		// params.put("materialCd", copyquantity);

		String retMsg = AppConstants.MSG_SUCCESS;

		cnt = ams.insertCopyAsset(assetid, copyquantity, loginId);
		if (cnt < 1) {

			retMsg = AppConstants.MSG_FAIL;
		}
		map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/assetCard.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> assetCard(@RequestBody Map<String, Object> params) throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;

		logger.debug("masterassetid  : {}", params.get("masterassetid"));
		List<EgovMap> list = ams.assetCardList(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveAssetCard.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAssetCard(@RequestBody Map<String, Object> params) throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		logger.debug("transAssetId  : {}", params.get("transAssetId"));
		logger.debug("transTypeId  : {}", params.get("transTypeId"));
		params.put("masterassetid", params.get("transAssetId"));
		params.put("cardTypeId", params.get("transTypeId"));
		params.put("loginId", loginId);
		ams.saveAssetCard(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveAssetCardReturn.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAssetCardReturn(@RequestBody Map<String, Object> params) throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		logger.debug("masterassetid  : {}", params.get("masterassetid"));
		params.put("loginId", loginId);
		ams.saveAssetCard(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveAssetStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAssetStatus(@RequestBody Map<String, Object> params) throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		logger.debug("statusAssetId  : {}", params.get("statusAssetId"));
		logger.debug("statusTypeId  : {}", params.get("statusTypeId"));
		params.put("masterassetid", params.get("statusAssetId"));
		params.put("cardTypeId", params.get("statusTypeId"));
		
		params.put("loginId", loginId);
		ams.updateAssetStatus(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveAssetCardBulk.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAssetCardBulk(@RequestBody Map<String, Object> params) throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		logger.debug("masterassetid  : {}", params.get("masterassetid"));

		// int masterassetid = Integer.parseInt(String.valueOf(params.get("masterassetidBulk")));
		// int trnsbranchid = Integer.parseInt(String.valueOf(params.get("trnsbranchidTo")));
		// int transdepartment = 0;
		// if (!"".equals(params.get("transdepartmentTo")) || null == params.get("transdepartmentTo")) {
		// transdepartment = Integer.parseInt(String.valueOf(params.get("transdepartmentTo")));
		// }
		// String cardTypeId = String.valueOf(params.get("cardTypeIdBulk"));
		Object masterassetid = params.get("masterassetidBulk");
		Object trnsbranchid = params.get("trnsbranchidTo");
		Object transdepartment = params.get("transdepartmentTo");
		Object cardTypeId = params.get("cardTypeIdBulk");

		params.put("loginId", loginId);
		params.put("masterassetid", masterassetid);
		params.put("trnsbranchid", trnsbranchid);
		params.put("transdepartment", transdepartment);
		params.put("cardTypeId", cardTypeId);
		ams.saveAssetCard(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/assetBulkList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> assetBulkList(@RequestBody Map<String, Object> params) throws Exception {
		logger.debug("status pram : {}", params.get("status"));
		logger.debug("searchbranchid  : {}", params.get("searchbranchid"));
		logger.debug("searchdeptid  : {}", params.get("searchdeptid"));
		int[] searchstatus = { 1 };
		logger.debug("searchstatus  : {}", searchstatus.toString());
		params.put("searchstatus", searchstatus);
		List<EgovMap> list = ams.selectAssetList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

}
