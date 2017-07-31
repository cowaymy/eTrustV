package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.MenuService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/menu")
public class MenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);

	@Autowired
	private MenuService menuService;

	@RequestMapping(value = "/getMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMenuList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(menuService.getMenuList(params));
	}
}
