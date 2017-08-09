package com.coway.trust.web.logistics.assetmaster;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.asset.AssetMngService;
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

	@RequestMapping(value = "/assetList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectCourierList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {	
		
		String searchassetid = request.getParameter("searchassetid");
		String[] searchstatus = request.getParameterValues("searchstatus");
		String searchbrand = request.getParameter("searchbrand");
		String searchmodelname = request.getParameter("searchmodelname");
		String searchpurchasedate1 = request.getParameter("searchpurchasedate1");
		String searchpurchasedate2 = request.getParameter("searchpurchasedate2");
//		String searchcategory = request.getParameter("searchcategory");
//		String searchcategory = request.getParameter("searchcategory");
//		String searchcategory = request.getParameter("searchcategory");
					
		Map<String, Object> assetmap = new HashMap();
		assetmap.put("searchassetid", searchassetid);
		assetmap.put("searchstatus" , searchstatus);
		assetmap.put("searchbrand"  ,	searchbrand );
		assetmap.put("searchmodelname"  ,	searchmodelname );
		assetmap.put("searchpurchasedate1"  ,	searchpurchasedate1 );
		assetmap.put("searchpurchasedate2"  ,	searchpurchasedate2 );

		List<EgovMap> list = ams.selectAssetList(assetmap);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}	
	
	
	@RequestMapping(value = "/selectDetailList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectDetailList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {	
		System.out.println("assetid :       "+request.getParameter("assetid"));
		String assetid = request.getParameter("assetid");
		
		Map<String, Object> assetdetailmap = new HashMap();
		assetdetailmap.put("assetid", assetid);

		List<EgovMap> list = ams.selectDetailList(assetdetailmap);
		
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
		
		return ResponseEntity.ok(BrandList);
	}
	
	@RequestMapping(value = "/selectTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTypeList(@RequestParam Map<String, Object> params) {
		
		params.put("hrchytypeid", "1198");

		List<EgovMap> TypeList = ams.selectTypeList(params);
		
		return ResponseEntity.ok(TypeList);
	}
	
	
	@RequestMapping(value = "/insertAssetMng.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertAssetMng(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		 //Map<String, Object> masterMap = (Map<String, Object>) params.get("masterForm");
		 Map<String, Object> detailMap= (Map<String, Object>) params.get("detailAddForm");
		 
		 List<EgovMap> detailAddList = (List<EgovMap>) detailMap.get(AppConstants.AUIGRID_ADD);
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

		// loginId
		params.put("masterstatus", 1);
		params.put("crt_user_id", loginId);
		params.put("upd_user_id", loginId);
		params.put("masterbreanch", 42);
		params.put("curr_dept_id", 38);
		params.put("curr_user_id", 0);
			
		Map<String, Object> map = new HashMap();

		try {
			ams.insertAssetMng(params,detailAddList);
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

		params.put("masterpurchasedate", CommonUtils.changeFormat((String)params.get("masterpurchasedate"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));		
		
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

		try {
			//ams.deleteAssetMng(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}
	
}
