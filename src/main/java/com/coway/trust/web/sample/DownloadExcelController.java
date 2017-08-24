package com.coway.trust.web.sample;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.view.ExcelXlsView;
import com.coway.trust.cmmn.view.ExcelXlsxStreamingView;
import com.coway.trust.cmmn.view.ExcelXlsxView;

@Controller
@RequestMapping("/sample/down")
public class DownloadExcelController {

	@Resource(name = "excelXlsView")
	private ExcelXlsView excelXlsView;

	@Resource(name = "excelXlsxView")
	private ExcelXlsxView excelXlsxView;

	@Resource(name = "excelXlsxStreamingView")
	private ExcelXlsxStreamingView excelXlsxStreamingView;

	@RequestMapping(value = "/excel-xls.do")
	public ModelAndView xlsView(@RequestParam Map<String, Object> params, ModelMap model) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(excelXlsView);
		Map<String, Object> excelData = getDefaultMap((String) params.get("fileName"));
		model.addAllAttributes(excelData);
		return modelAndView;
	}

	@RequestMapping(value = "/excel-xlsx.do")
	public ModelAndView xlsxView(@RequestParam Map<String, Object> params, ModelMap model) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(excelXlsxView);
		Map<String, Object> excelData = getDefaultMap((String) params.get("fileName"));
		model.addAllAttributes(excelData);
		return modelAndView;
	}

	@RequestMapping(value = "/excel-xlsx-streaming.do")
	public ModelAndView xlsxStreamingView(@RequestParam Map<String, Object> params, ModelMap model) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(excelXlsxStreamingView);
		Map<String, Object> excelData = getDefaultMap((String) params.get("fileName"));
		model.addAllAttributes(excelData);
		return modelAndView;
	}

	// sample data 생성.
	private Map<String, Object> getDefaultMap(String fileName) {
		Map<String, Object> map = new HashMap<>();
		// 다운로드 파일명
		map.put(AppConstants.FILE_NAME, fileName);
		// 엑셀 헤더 부분
		map.put(AppConstants.HEAD, Arrays.asList("ID", "NAME", "COMMENT"));
		// 데이터 설정.
		map.put(AppConstants.BODY, Arrays.asList(Arrays.asList("A", "a", "가"), Arrays.asList("B", "b", "나"),
				Arrays.asList("C", "c", "다")));
		return map;
	}
}
