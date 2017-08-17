package com.coway.trust.web.logistics.sirim;

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

import com.coway.trust.biz.logistics.sirim.SirimService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/sirim")
public class SirimController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "SirimService")
	private SirimService SirimService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/sirimList.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sirim/sirimList";
	}
	
	//셀렉트박스 조회
	@RequestMapping(value = "/selectWarehouseList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWarehouseList(@RequestParam Map<String, Object> params) {
		List<EgovMap> warehouseList = SirimService.selectWarehouseList(params);
//		for (int i = 0; i < warehouseList.size(); i++) {
//			logger.debug("%%%%%%%%warehouseList%%%%%%%: {}", warehouseList.get(i));
//		}

		return ResponseEntity.ok(warehouseList);
	}
	
	
	@RequestMapping(value = "/selectSirimList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSirimList(@RequestBody Map<String, Object> params, Model model) {
		
		logger.debug("%%%%%%%%sirimList%%%%%%%: {}",params.get("searchSirimNo") );
		logger.debug("%%%%%%%%sirimList%%%%%%%: {}",params.get("searchCategory") );
		logger.debug("%%%%%%%%sirimList%%%%%%%: {}",params.get("searchWarehouse") );
		
		List<EgovMap> list = SirimService.selectSirimList(params);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	
	
	
	

}
