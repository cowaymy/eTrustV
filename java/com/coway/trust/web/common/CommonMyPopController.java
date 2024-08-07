package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.common.CommonMyPopService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class CommonMyPopController {	
	@Autowired
	private CommonMyPopService commonMyPopService;
		
	@RequestMapping(value = "/commonMyPop.do")
	public String menuPop(@RequestParam Map<String, Object> params, ModelMap model) {							
		return "common/commonMyPop";
	}
	
	@RequestMapping(value = "/selectCommonMyPop.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommonMyPop(@RequestParam Map<String, Object> params, ModelMap model) {						
		return ResponseEntity.ok(commonMyPopService.selectCommonMyPopList(params));
	}	
}
