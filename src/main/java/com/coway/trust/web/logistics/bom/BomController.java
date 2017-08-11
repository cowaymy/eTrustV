package com.coway.trust.web.logistics.bom;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.bom.BomService;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.logistics.courier.CourierController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/bom")
public class BomController {
	private static final Logger logger = LoggerFactory.getLogger(CourierController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "bomService")
	private BomService bomService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/bomList.do")
	public String BOMList(@RequestParam Map<String, Object> params, ModelMap model) {

		return "logistics/bom/bomList";
	}

	@RequestMapping(value = "selectCdcList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCdcList(@RequestParam Map<String, Object> params) {
		List<EgovMap> cdcList = bomService.selectCdcList(params);
		return ResponseEntity.ok(cdcList);
	}

	@RequestMapping(value = "/selectBomList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectBomList(@RequestBody Map<String, Object> params, ModelMap model)
			throws Exception {

		List<EgovMap> list = bomService.selectBomList(params);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("data", list);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/materialInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> materialInfo(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String bom = request.getParameter("bom");
		logger.debug("bom : {}", request.getParameter("bom"));
		Map<String, Object> params = new HashMap();
		params.put("bom", bom);

		List<EgovMap> info = bomService.materialInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/filterInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> filterInfo(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String bom = request.getParameter("bom");
		String categoryid = request.getParameter("categoryid");

		Map<String, Object> params = new HashMap();
		params.put("categoryid", categoryid);
		params.put("bom", bom);

		List<EgovMap> info = bomService.filterInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/spareInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> spareInfo(ModelMap model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String bom = request.getParameter("bom");
		String categoryid = request.getParameter("categoryid");

		Map<String, Object> params = new HashMap();
		params.put("categoryid", categoryid);
		params.put("bom", bom);

		List<EgovMap> info = bomService.spareInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("data", info);
		return ResponseEntity.ok(map);
	}
}
