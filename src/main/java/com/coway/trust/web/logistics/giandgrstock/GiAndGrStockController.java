/**
 * @author Adrian C.
 **/
package com.coway.trust.web.logistics.giandgrstock;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.giandgrstock.GiAndGrStockService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/giandgrStock")
public class GiAndGrStockController
{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "GiAndGrStockService")
	private GiAndGrStockService giAndGrStockService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/giandgrStockList.do")
	public String GiAndGrStockList(Model model, HttpServletRequest request, HttpServletResponse response)
	throws Exception
	{
		return "logistics/giandgrstock/giAndGrStockList";
	}

	@RequestMapping(value = "/selectLocation.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLocation(@RequestParam Map<String, Object> params)
	{
		logger.debug("selectBrandListCode : {}", params.get("groupCode"));

		List<EgovMap> LocationList = giAndGrStockService.selectLocation(params);

		return ResponseEntity.ok(LocationList);
	}

	@RequestMapping(value = "/stockBalanceSearchList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> stockBalanceSearchList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model)
	throws Exception
	{
		String basedt = request.getParameter("basedt");
		String tobasedt = request.getParameter("tobasedt");
		String[] loctype = request.getParameterValues("loctype");
		String locgrade = request.getParameter("locgrade");
		String[] locname = request.getParameterValues("locname");
		String materialcode = request.getParameter("searchMaterialCode");
		String[] smattype = request.getParameterValues("smattype");
		String[] smatcate = request.getParameterValues("smatcate");

		Map<String, Object> pmap = new HashMap();

		pmap.put("basedt", basedt);
		pmap.put("tobasedt", tobasedt);
		pmap.put("loctype", loctype);
		pmap.put("locgrade", locgrade);
		pmap.put("locname", locname);
		pmap.put("materialcode", materialcode);
		pmap.put("smattype", smattype);
		pmap.put("smatcate", smatcate);

		List<EgovMap> list = giAndGrStockService.stockBalanceSearchList(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectStockBalanceDetailsList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectStockBalanceDetailsList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model)
	throws Exception
	{
		String itmcode = request.getParameter("detailStkCode");
		String basedt = request.getParameter("detailBaseDt");
		String postingdt = request.getParameter("postingdt");
		String loccode = request.getParameter("detailLocCode");
		String[] transtype      = request.getParameterValues("searchTrcType");
		String[] movetype      = request.getParameterValues("searchMoveType");

		Map<String, Object> pmap = new HashMap();

		pmap.put("itmcode", itmcode);
		pmap.put("basedt", basedt);
		pmap.put("postingdt", postingdt);
		pmap.put("loccode", loccode);
		pmap.put("transtype", transtype);
		pmap.put("movetype", movetype);

		List<EgovMap> list = giAndGrStockService.selectStockBalanceDetailsList(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectTrntype.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTrntype(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model)
	throws Exception
	{
		List<EgovMap> result = null;

		String[] searchTrcType = request.getParameterValues("searchTrcType");

		Map<String, Object> map = new HashMap();
		map.put("strctype", searchTrcType);

		result = giAndGrStockService.stockBalanceMovementType(map);

		return ResponseEntity.ok(result);
	}
}