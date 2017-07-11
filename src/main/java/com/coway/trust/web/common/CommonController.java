package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.config.DatabaseDrivenMessageSource;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class CommonController {

	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private DatabaseDrivenMessageSource dbMessageSource;

	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = commonService.selectCodeList(params);
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/generalCode.do")
	public String listCommCode(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "/common/generalCodeManagement";
	}
	
	@RequestMapping(value = "/selectMstCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeMstList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("commCodeMstId : {}", params.get("cdMstId"));

		List<EgovMap> mstCommCodeList = commonService.getMstCommonCodeList(params);
		
		return ResponseEntity.ok(mstCommCodeList);

	}
	
	@RequestMapping(value = "/selectDetailCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("commDetailCodeMstId : {}", params.get("cdMstId"));
		
		List<EgovMap> mstCommDetailCodeList = commonService.getDetailCommonCodeList(params);
		
		return ResponseEntity.ok(mstCommDetailCodeList);
		
	}

	@RequestMapping(value = "/unauthorized.do")
	public String unauthorized(@RequestParam Map<String, Object> params, ModelMap model) {
		return "/error/unauthorized";
	}

	@RequestMapping(value = "/db-messages/reload.do")
	public void reload(@RequestParam Map<String, Object> params, ModelMap model) {
		dbMessageSource.reload();
	}
}
