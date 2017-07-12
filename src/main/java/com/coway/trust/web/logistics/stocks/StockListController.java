package com.coway.trust.web.logistics.stocks;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.coway.trust.util.CommonUtils;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.coway.trust.AppConstants;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.coway.trust.biz.logistics.stocks.StockService;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/stock")
public class StockListController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "stockService")
	private StockService stock;
	
//	public String StockList(@ModelAttribute("searchVO") SampleDefaultVO searchVO, ModelMap model,
//			@RequestParam Map<String, Object> params) throws Exception {
//		return "Stock/StockList";
//	}
	@RequestMapping(value = "/Stock.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "logistics/Stock/StockList";
	}
	
	@RequestMapping(value = "/StockList.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockList( ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
	//public ResponseEntity<Map> selectStockList( @RequestBody Map<String , Object> params , ModelMap model) throws Exception {
	//public ResponseEntity<Map<String, Object>> selectStockList(HttpServletRequest req, HttpServletResponse res,@RequestBody Map<String, Object> params, @RequestParam Map<String, Object> queryString, Model model) {
		String[] cate   = request.getParameterValues("cmbCategory");
		String[] type   = request.getParameterValues("cmbType");
		String[] status = request.getParameterValues("cmbStatus");
		String stkNm    = request.getParameter("stkNm");
		String stkCd    = request.getParameter("stkCd");
		//System.out.println(" :::::: " + params.size());
		/*List<String> param = (List<String>) params.get("cmbCategory");
		for (String tt : param){
			System.out.println(" :: " + tt);
		}*/
		
		Map<String, Object> smap = new HashMap();
		smap.put("cateList" , cate);
		smap.put("typeList" , type);
		smap.put("statList" , status);
		smap.put("stkNm"    , stkNm);
		smap.put("stkCd"    , stkCd);
		
		List<EgovMap> list = stock.selectStockList(smap);
		
		Map<String, Object> map = new HashMap();
		map.put("data" , list);
    	
		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/StockInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockInfo( ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String stkid = request.getParameter("stkid");
		String mode  = CommonUtils.nvl(request.getParameter("mode"));
		
		Map<String, Object> smap = new HashMap();
		smap.put("stockId" , stkid);
		smap.put("mode" , mode);
	
		List<EgovMap> info = stock.selectStockInfo(smap);
		
		Map<String, Object> map = new HashMap();
		map.put("data" , info);    	
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/PriceInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectPriceInfo( ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String stkid  = CommonUtils.nvl(request.getParameter("stkid"));
		String typeid = CommonUtils.nvl(request.getParameter("typeid"));
		
		Map<String, Object> smap = new HashMap();
		smap.put("stockId" , stkid);
		smap.put("typeId" , typeid);
	
		List<EgovMap> info = stock.selectPriceInfo(smap);
		
		Map<String, Object> map = new HashMap();
		map.put("data" , info);    	
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/FilterInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectFilterInfo( ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String stkid  = CommonUtils.nvl(request.getParameter("stkid"));
		String grid  = CommonUtils.nvl(request.getParameter("grid"));
		
		Map<String, Object> smap = new HashMap();
		smap.put("stockId" , stkid);
		smap.put("grid"    , grid);
	
		List<EgovMap> info = stock.selectFilterInfo(smap);
		
		Map<String, Object> map = new HashMap();
		map.put("data" , info);    	
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/ServiceInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectServiceInfo( ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String stkid  = CommonUtils.nvl(request.getParameter("stkid"));
		
		Map<String, Object> smap = new HashMap();
		smap.put("stockId" , stkid);
	
		List<EgovMap> info = stock.selectServiceInfo(smap);
		
		Map<String, Object> map = new HashMap();
		map.put("data" , info);    	
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectStockImgList.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectStockImgList( ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String stkid  = CommonUtils.nvl(request.getParameter("stkid"));
		
		Map<String, Object> smap = new HashMap();
		smap.put("stockId" , stkid);
	
		List<EgovMap> imglist = stock.selectStockImgList(smap);
		
		Map<String, Object> map = new HashMap();
		map.put("data" , imglist);
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/modifyStockInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> modifyStockInfo(@RequestBody Map<String, Object> params, Model model)
			throws Exception {
		//sampleService.saveTransaction(params);
		String retMsg = AppConstants.MSG_SUCCESS;
		
		//loginId
		params.put("upd_user", 99999999);
		
		Map<String, Object> map = new HashMap();
		map.put("revalue" , (String)params.get("revalue"));
		map.put("stkid"   , (Integer)params.get("stockId"));
		
		try{
			stock.updateStockInfo(params);			
		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg" , retMsg);
		}
		
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/modifyPriceInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> modifyPriceInfo(@RequestBody Map<String, Object> params, Model model)
			throws Exception {
		//sampleService.saveTransaction(params);
		String retMsg = AppConstants.MSG_SUCCESS;
		System.out.println("197Line :::::: " + params.get("priceTypeid"));
		//loginId
		params.put("upd_user", 99999999);
		
		Map<String, Object> map = new HashMap();
		map.put("revalue" , (String)params.get("revalue"));
		map.put("stkid"   , (Integer)params.get("stockId"));
		map.put("msg" , retMsg);
		
		stock.updatePriceInfo(params);			
		
		return ResponseEntity.ok(map);
	}

}
