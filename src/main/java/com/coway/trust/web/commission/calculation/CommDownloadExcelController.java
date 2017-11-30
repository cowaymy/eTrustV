package com.coway.trust.web.commission.calculation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.cmmn.view.ExcelXlsView;
import com.coway.trust.cmmn.view.ExcelXlsxStreamingView;
import com.coway.trust.cmmn.view.ExcelXlsxView;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/commission/down")
public class CommDownloadExcelController {
	
	@Resource(name = "commissionCalculationService")
	private CommissionCalculationService commissionCalculationService;

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
		Map<String, Object> excelData = getDefaultMap(params);
		model.addAllAttributes(excelData);
		return modelAndView;
	}

	@RequestMapping(value = "/excel-xlsx.do")
	public ModelAndView xlsxView(@RequestParam Map<String, Object> params, ModelMap model) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(excelXlsxView);
		Map<String, Object> excelData = getDefaultMap(params);
		model.addAllAttributes(excelData);
		return modelAndView;
	}

	@RequestMapping(value = "/excel-xlsx-streaming.do")
	public ModelAndView xlsxStreamingView(@RequestParam Map<String, Object> params, ModelMap model) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setView(excelXlsxStreamingView);
		Map<String, Object> excelData = getDefaultMap(params);
		model.addAllAttributes(excelData);
		return modelAndView;
	}

	// sample data 생성.
	private Map<String, Object> getDefaultMap(Map<String, Object> params) {
	
		int pvMonth = Integer.parseInt(params.get("month").toString());
		int pvYear = Integer.parseInt(params.get("year").toString());
		int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);
		params.put("taskId", sTaskID);
		
		Map<String, Object> map = new HashMap<>();
		// 다운로드 파일명
		String fileName = (String)params.get("fileName");
		map.put(AppConstants.FILE_NAME, fileName);
		// 엑셀 헤더 부분
		
		// 데이터 설정.
		ArrayList<ArrayList<String>> getBodyDataList = new ArrayList<>();
		ArrayList<String> getHeadData = new ArrayList<>();
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CTM_P01) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CTR_P01)){
			params.put("codeGruop", CommissionConstants.COMIS_CT);
			getHeadData = getDataHead7001CT(params);
			getBodyDataList=getDataList7001CT(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CDG_P01) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDM_P01)|| (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01)
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDS_P01)){
			params.put("codeGruop", CommissionConstants.COMIS_CD);
			getHeadData = getDataHead7001CD(params);
			getBodyDataList=getDataList7001CD(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01) || (params.get("code")).equals(CommissionConstants.COMIS_HPG_P01) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPM_P01)|| (params.get("code")).equals(CommissionConstants.COMIS_HPS_P01)
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPT_P01)){
			params.put("codeGruop", CommissionConstants.COMIS_HP);
			getHeadData = getDataHead7001HP(params);
			getBodyDataList=getDataList7001HP(params);
		}
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CTM_P02) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CTR_P02)){
			params.put("codeGruop", CommissionConstants.COMIS_CT);
			getHeadData = getDataHead7002CT(params);
			getBodyDataList = getDataList7002CT(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CDG_P02) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDM_P02)|| (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02)
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDS_P02)){
			params.put("codeGruop", CommissionConstants.COMIS_CD);
			getHeadData = getDataHead7002CD(params);
			getBodyDataList = getDataList7002CD(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02) || (params.get("code")).equals(CommissionConstants.COMIS_HPG_P02) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPM_P02)|| (params.get("code")).equals(CommissionConstants.COMIS_HPS_P02)
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPT_P02) || (params.get("code")).equals(CommissionConstants.COMIS_HPB_P02)){
			params.put("codeGruop", CommissionConstants.COMIS_HP);
			getHeadData = getDataHead7002HP(params);
			getBodyDataList = getDataList7002HP(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P01)){
			getHeadData = getDataHead06T(params);
			getBodyDataList = getDataList06T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P02)){
			getHeadData = getDataHead07T(params);
			getBodyDataList = getDataList07T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P03)){
			getHeadData = getDataHead08T(params);
			getBodyDataList = getDataList08T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P04)){
			getHeadData = getDataHead09T(params);
			getBodyDataList = getDataList09T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P05)){
			getHeadData = getDataHead10T(params);
			getBodyDataList = getDataList10T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P06)){
			getHeadData = getDataHead11T(params);
			getBodyDataList = getDataList11T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P07)){
			getHeadData = getDataHead12T(params);
			getBodyDataList = getDataList12T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P08)){
			getHeadData = getDataHead13T(params);
			getBodyDataList = getDataList13T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P09)){
			getHeadData = getDataHead14T(params);
			getBodyDataList = getDataList14T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P010)){
			getHeadData = getDataHead15T(params);
			getBodyDataList = getDataList15T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P01)){
			getHeadData = getDataHead16T(params);
			getBodyDataList = getDataList16T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P011)){
			getHeadData = getDataHead17T(params);
			getBodyDataList = getDataList17T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P012)){
			getHeadData = getDataHead22T(params);
			getBodyDataList = getDataList22T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P013)){
			getHeadData = getDataHead23T(params);
			getBodyDataList = getDataList23T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P014)){
			getHeadData = getDataHead25T(params);
			getBodyDataList = getDataList25T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P015)){
			getHeadData = getDataHead26T(params);
			getBodyDataList = getDataList26T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P01)){
			getHeadData = getDataHead18T(params);
			getBodyDataList = getDataList18T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P02)){
			getHeadData = getDataHead19T(params);
			getBodyDataList = getDataList19T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P03)){
			getHeadData = getDataHead20T(params);
			getBodyDataList = getDataList20T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P04)){
			getHeadData = getDataHead21T(params);
			getBodyDataList = getDataList21T(params);
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P05)){
			getHeadData = getDataHead24T(params);
			getBodyDataList = getDataList24T(params);
		}
		
		map.put(AppConstants.HEAD, getHeadData);
		map.put(AppConstants.BODY, getBodyDataList);
		/*map.put(AppConstants.BODY, Arrays.asList(Arrays.asList("A", "a", "가"), Arrays.asList("B", "b", "나"),
				Arrays.asList("C", "c", "다")));*/
		return map;
	}
	private ArrayList<String> getDataHead7001CT(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		head.add("taskId");
		head.add("runId");
		head.add("emplyId");
		head.add("memType");
		head.add("AS Count"); 
		head.add("AS Sum CP"); 
		head.add("BS Count"); 
		head.add("BS Sum CP");
		head.add("Ins Count ");
		head.add("Ins Sum CP"); 
		head.add("PR Count"); 
		head.add("PR Sum CP"); 
		head.add("Total Point "); 
		head.add("Pro Percent"); 
		head.add("Per Percent "); 
		head.add("Pro Factor (30%)");
		head.add("Per Factor (70%) "); 
		head.add("Sum Factor");
		
		return head;
	}
	private ArrayList<String> getDataHead7001CD(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		head.add("taskId");
		head.add("runId");
		head.add("emplyId");
		head.add("memType");
		head.add("v1"); 
		head.add("v2"); 
		head.add("v3"); 
		head.add("v4"); 
		head.add("v5");
		head.add("v6"); 
		head.add("v7"); 
		head.add("v8"); 
		head.add("v9"); 
		head.add("v10"); 
		head.add("v11"); 
		head.add("v12");
		head.add("v13"); 
		head.add("v14");
		head.add("v15"); 
		head.add("v16");
		head.add("v17"); 
		head.add("v18");
		head.add("v19"); 
		head.add("v20");
		head.add("v21"); 
		head.add("v22");
		head.add("v23"); 
		head.add("v24"); 
		head.add("v25"); 
		head.add("v26"); 
		head.add("v27"); 
		head.add("v29");
		head.add("v30");
		head.add("v31"); 
		head.add("v32"); 
		head.add("v33");
		return head;
	}
	private ArrayList<String> getDataHead7001HP(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		head.add("taskId");
		head.add("runId");
		head.add("emplyId");
		head.add("memType");
		head.add("v1"); 
		head.add("v8"); 
		head.add("v9"); 
		head.add("v13"); 
		head.add("v14");
		head.add("v15"); 
		head.add("v16");
		head.add("v17"); 
		head.add("v18");
		head.add("v19"); 
		head.add("v20");
		head.add("v21"); 
		head.add("v22");
		head.add("v24"); 
		head.add("v25"); 
		head.add("v26"); 
		head.add("v27"); 
		head.add("v28");
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList7001CT(Map<String, Object> params){
		if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(params.get("taskId").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("memType").toString());
			lst.add(dataList.get(i).get("v1").toString());
			lst.add(dataList.get(i).get("v2").toString());
			lst.add(dataList.get(i).get("v3").toString());
			lst.add(dataList.get(i).get("v4").toString());
			lst.add(dataList.get(i).get("v5").toString());
			lst.add(dataList.get(i).get("v6").toString());
			lst.add(dataList.get(i).get("v7").toString());
			lst.add(dataList.get(i).get("v8").toString());
			lst.add(dataList.get(i).get("v9").toString());
			lst.add(dataList.get(i).get("v10").toString());
			lst.add(dataList.get(i).get("v11").toString());
			lst.add(dataList.get(i).get("v12").toString());
			lst.add(dataList.get(i).get("v13").toString());
			lst.add(dataList.get(i).get("v14").toString());
			
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<ArrayList<String>> getDataList7001CD(Map<String, Object> params){
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(params.get("taskId").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("memType").toString());
			lst.add(dataList.get(i).get("v1").toString());
			lst.add(dataList.get(i).get("v2").toString());
			lst.add(dataList.get(i).get("v3").toString());
			lst.add(dataList.get(i).get("v4").toString());
			lst.add(dataList.get(i).get("v5").toString());
			lst.add(dataList.get(i).get("v6").toString());
			lst.add(dataList.get(i).get("v7").toString());
			lst.add(dataList.get(i).get("v8").toString());
			lst.add(dataList.get(i).get("v9").toString());
			lst.add(dataList.get(i).get("v10").toString());
			lst.add(dataList.get(i).get("v11").toString());
			lst.add(dataList.get(i).get("v12").toString());
			lst.add(dataList.get(i).get("v13").toString());
			lst.add(dataList.get(i).get("v14").toString());
			lst.add(dataList.get(i).get("v15").toString());
			lst.add(dataList.get(i).get("v16").toString());
			lst.add(dataList.get(i).get("v17").toString());
			lst.add(dataList.get(i).get("v18").toString());
			lst.add(dataList.get(i).get("v19").toString());
			lst.add(dataList.get(i).get("v20").toString());
			lst.add(dataList.get(i).get("v21").toString());
			lst.add(dataList.get(i).get("v22").toString());
			lst.add(dataList.get(i).get("v23").toString());
			lst.add(dataList.get(i).get("v24").toString());
			lst.add(dataList.get(i).get("v25").toString());
			lst.add(dataList.get(i).get("v26").toString());
			lst.add(dataList.get(i).get("v27").toString());
			lst.add(dataList.get(i).get("v29").toString());
			lst.add(dataList.get(i).get("v30").toString());
			lst.add(dataList.get(i).get("v31").toString());
			lst.add(dataList.get(i).get("v32").toString());
			lst.add(dataList.get(i).get("v33").toString());
			
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<ArrayList<String>> getDataList7001HP(Map<String, Object> params){
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P01))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(params.get("taskId").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("memType").toString());
			lst.add(dataList.get(i).get("v1").toString());
			lst.add(dataList.get(i).get("v8").toString());
			lst.add(dataList.get(i).get("v9").toString());
			lst.add(dataList.get(i).get("v13").toString());
			lst.add(dataList.get(i).get("v14").toString());
			lst.add(dataList.get(i).get("v15").toString());
			lst.add(dataList.get(i).get("v16").toString());
			lst.add(dataList.get(i).get("v17").toString());
			lst.add(dataList.get(i).get("v18").toString());
			lst.add(dataList.get(i).get("v19").toString());
			lst.add(dataList.get(i).get("v20").toString());
			lst.add(dataList.get(i).get("v21").toString());
			lst.add(dataList.get(i).get("v22").toString());
			lst.add(dataList.get(i).get("v24").toString());
			lst.add(dataList.get(i).get("v25").toString());
			lst.add(dataList.get(i).get("v26").toString());
			lst.add(dataList.get(i).get("v27").toString());
			lst.add(dataList.get(i).get("v28").toString());
			
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<String> getDataHead7002CT(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		head.add("taskId");
		head.add("runId");
		head.add("emplyId");
		head.add("memType");
		head.add("Gross Comm"); 
		head.add("Rental Comm");
		head.add("Srv Mem Comm"); 
		head.add("Basic and Allowance");
		head.add("Performance Incentive");
		head.add("Adjustment"); 
		head.add("CFF + Reward");
		head.add("Seniority");

		return head;
	}
	private ArrayList<String> getDataHead7002CD(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		head.add("taskId");
		head.add("runId");
		head.add("emplyId");
		head.add("memType");
		head.add("Per_Amt"); 
		head.add("R2");
		head.add("R3"); 
		head.add("Bonus_Amt");
		head.add("R5");
		head.add("Collect_Amt"); 
		head.add("HP_Amt");
		head.add("Transport_Amt"); 
		head.add("NewCody_Amt");
		head.add("Introduction_Fees"); 
		head.add("Membership_Amt");
		head.add("R18"); 
		head.add("R19");
		head.add("R20"); 
		head.add("R21");
		head.add("R22"); 
		head.add("R23");
		head.add("R24"); 
		head.add("Telephone_Deduct");
		head.add("Staff_Purchase"); 
		head.add("R28");
		head.add("SHI_Amt");
		head.add("R30");
		head.add("R31"); 
		head.add("R32");
		head.add("R33"); 
		head.add("RentalMembership_Amt");
		head.add("RentalMembership_SHI_Amt"); 
		head.add("R36");
		head.add("R38"); 
		head.add("R39");
		head.add("R40"); 
		head.add("R41");
		head.add("R42");
		head.add("Adjustment");
		
		return head;
	}
	private ArrayList<String> getDataHead7002HP(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		head.add("taskId");
		head.add("runId");
		head.add("emplyId");
		head.add("memType");
		head.add("PI");
		head.add("R2");
		head.add("R3"); 
		head.add("Bonus");
		head.add("PA");
		head.add("Membership_Amt"); 
		head.add("R18"); 
		head.add("R19"); 
		head.add("R20"); 
		head.add("R21"); 
		head.add("R22");
		head.add("TBB_Amt");
		head.add("R24"); 
		head.add("Incentive");
		head.add("SHI_Amt"); 
		head.add("R30");
		head.add("R31"); 
		head.add("R32");
		head.add("R33");
		head.add("RentalMembership_Amt");
		head.add("RentalMembership_SHI_Amt"); 
		head.add("R36");
		head.add("R39"); 
		head.add("R40");
		head.add("R41"); 
		head.add("R42"); 
		head.add("Adjust_Amt");
		
		return head;
	}
	
	private ArrayList<ArrayList<String>> getDataList7002CT(Map<String, Object> params){
		if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(params.get("taskId").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("memType").toString());
			lst.add(dataList.get(i).get("r1").toString());
			lst.add(dataList.get(i).get("r2").toString());
			lst.add(dataList.get(i).get("r3").toString());
			lst.add(dataList.get(i).get("r4").toString());
			lst.add(dataList.get(i).get("r5").toString());
			lst.add(dataList.get(i).get("r6").toString());
			lst.add(dataList.get(i).get("r7").toString());
			lst.add(dataList.get(i).get("r8").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<ArrayList<String>> getDataList7002CD(Map<String, Object> params){
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(params.get("taskId").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("memType").toString());
			lst.add(dataList.get(i).get("r1").toString());
			lst.add(dataList.get(i).get("r2").toString());
			lst.add(dataList.get(i).get("r3").toString());
			lst.add(dataList.get(i).get("r4").toString());
			lst.add(dataList.get(i).get("r5").toString());
			lst.add(dataList.get(i).get("r6").toString());
			lst.add(dataList.get(i).get("r7").toString());
			lst.add(dataList.get(i).get("r8").toString());
			lst.add(dataList.get(i).get("r10").toString());
			lst.add(dataList.get(i).get("r11").toString());
			lst.add(dataList.get(i).get("r13").toString());
			lst.add(dataList.get(i).get("r18").toString());
			lst.add(dataList.get(i).get("r19").toString());
			lst.add(dataList.get(i).get("r20").toString());
			lst.add(dataList.get(i).get("r21").toString());
			lst.add(dataList.get(i).get("r22").toString());
			lst.add(dataList.get(i).get("r23").toString());
			lst.add(dataList.get(i).get("r24").toString());
			lst.add(dataList.get(i).get("r26").toString());
			lst.add(dataList.get(i).get("r27").toString());
			lst.add(dataList.get(i).get("r28").toString());
			lst.add(dataList.get(i).get("r29").toString());
			lst.add(dataList.get(i).get("r30").toString());
			lst.add(dataList.get(i).get("r31").toString());
			lst.add(dataList.get(i).get("r32").toString());
			lst.add(dataList.get(i).get("r33").toString());
			lst.add(dataList.get(i).get("r34").toString());
			lst.add(dataList.get(i).get("r35").toString());
			lst.add(dataList.get(i).get("r36").toString());
			lst.add(dataList.get(i).get("r38").toString());
			lst.add(dataList.get(i).get("r39").toString());
			lst.add(dataList.get(i).get("r40").toString());
			lst.add(dataList.get(i).get("r41").toString());
			lst.add(dataList.get(i).get("r42").toString());
			lst.add(dataList.get(i).get("r99").toString());
				
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<ArrayList<String>> getDataList7002HP(Map<String, Object> params){
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02) || (params.get("code")).equals(CommissionConstants.COMIS_HPB_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P02))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(params.get("taskId").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("memType").toString());
			lst.add(dataList.get(i).get("r1").toString());
			lst.add(dataList.get(i).get("r2").toString());
			lst.add(dataList.get(i).get("r3").toString());
			lst.add(dataList.get(i).get("r4").toString());
			lst.add(dataList.get(i).get("r5").toString());
			lst.add(dataList.get(i).get("r13").toString());
			lst.add(dataList.get(i).get("r18").toString());
			lst.add(dataList.get(i).get("r19").toString());
			lst.add(dataList.get(i).get("r20").toString());
			lst.add(dataList.get(i).get("r21").toString());
			lst.add(dataList.get(i).get("r22").toString());
			lst.add(dataList.get(i).get("r25").toString());
			lst.add(dataList.get(i).get("r28").toString());
			lst.add(dataList.get(i).get("r29").toString());
			lst.add(dataList.get(i).get("r30").toString());
			lst.add(dataList.get(i).get("r31").toString());
			lst.add(dataList.get(i).get("r32").toString());
			lst.add(dataList.get(i).get("r33").toString());
			lst.add(dataList.get(i).get("r34").toString());
			lst.add(dataList.get(i).get("r35").toString());
			lst.add(dataList.get(i).get("r36").toString());
			lst.add(dataList.get(i).get("r39").toString());
			lst.add(dataList.get(i).get("r40").toString());
			lst.add(dataList.get(i).get("r41").toString());
			lst.add(dataList.get(i).get("r42").toString());
			lst.add(dataList.get(i).get("r99").toString());
				
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<ArrayList<String>> getDataList(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0018T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			String runId = dataList.get(i).get("runId").toString();
			String ordId = dataList.get(i).get("ordId").toString();
			String instId = dataList.get(i).get("instId").toString();
			String stockId = dataList.get(i).get("stockId").toString();
			String appTypeId = dataList.get(i).get("appTypeId").toString();
			String memid = dataList.get(i).get("memid").toString();
			String prc = dataList.get(i).get("prc").toString();
			String memType = dataList.get(i).get("memType").toString();
			lst.add(params.get("taskId").toString());
			lst.add(runId);
			lst.add(ordId);
			lst.add(instId);
			lst.add(stockId);
			lst.add(appTypeId);
			lst.add(memid);
			lst.add(prc);
			lst.add(memType);
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	
	
	private ArrayList<String> getDataHead06T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("DEPT CODE");		
		head.add("MANGR ID");
		head.add("MEM ID");				
		head.add("EMPLY TYPE CODE");
		head.add("JOIN DT");			
		head.add("EMPLY LEV");
		head.add("EMPLY LEV AGE");	
		head.add("WORKING MONTH");	
		head.add("EMPLY STUS ID");
		head.add("EMPLY STUS CODE");
		head.add("EMPLY LEV RANK");
		head.add("EMPLY VEH");		
		head.add("EMPLY BIZ TYPE_ID");
		head.add("MANGR_CODE");
		head.add("EMPLY_CODE");
		head.add("PAY_STUS");
		head.add("IS_HSPTLZ");
		head.add("IS EXCLUDE");
		head.add("RUN ID");				
		head.add("COMM TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList06T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0006T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("deptCode").toString());
			lst.add(dataList.get(i).get("mangrid").toString());
			lst.add(dataList.get(i).get("memId").toString());
			lst.add(dataList.get(i).get("emplyTypeCode").toString());
			lst.add(dataList.get(i).get("joindt").toString());
			lst.add(dataList.get(i).get("emplyLev").toString());
			lst.add(dataList.get(i).get("emplyLevAge").toString());
			lst.add(dataList.get(i).get("workingMonth").toString());
			lst.add(dataList.get(i).get("emplyStusId").toString());
			lst.add(dataList.get(i).get("emplyStusCode").toString());
			lst.add(dataList.get(i).get("emplyLevRank").toString());
			lst.add(dataList.get(i).get("emplyveh").toString());
			lst.add(dataList.get(i).get("emplyBizTypeId").toString());
			lst.add(dataList.get(i).get("mangrcode").toString());
			lst.add(dataList.get(i).get("emplycode").toString());
			lst.add(dataList.get(i).get("paystus").toString());
			lst.add(dataList.get(i).get("ishsptlz").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead07T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD ID");			
		head.add("MEM ID");
		head.add("CODE");
		head.add("ORD TYPE ID");	
		head.add("PRODUCT ID");
		head.add("UNIT VALU");	
		head.add("PRC");
		head.add("PV VALU");
		head.add("IS EXCLUDE");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList07T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0007T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("memId").toString());
			lst.add(dataList.get(i).get("code").toString());
			lst.add(dataList.get(i).get("ordTypeId").toString());
			lst.add(dataList.get(i).get("productId").toString());
			lst.add(dataList.get(i).get("unitValu").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(dataList.get(i).get("pvValu").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead08T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("BS_SCHDUL_ID");	
		head.add("SVC_PERSON_ID");
		head.add("BS_STUS_ID");		
		head.add("CRDIT_POINT");		
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList08T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0008T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("bsSchdulId").toString());
			lst.add(dataList.get(i).get("svcPersonId").toString());
			lst.add(dataList.get(i).get("bsStusId").toString());
			lst.add(dataList.get(i).get("crditPoint").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead09T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("SVC_PERSON_ID");
		head.add("HAPY_CALL_ID");
		head.add("ORD_ID");		
		head.add("CUST_RESPNS_ID");
		head.add("APPRAN");
		head.add("XPLNT");		
		head.add("QLY");
		head.add("OVERAL");	
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList09T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0009T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("svcPersonId").toString());
			lst.add(dataList.get(i).get("hapyCallId").toString());
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("custRespnsId").toString());
			lst.add(dataList.get(i).get("appran").toString());
			lst.add(dataList.get(i).get("xplnt").toString());
			lst.add(dataList.get(i).get("qly").toString());
			lst.add(dataList.get(i).get("overal").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead10T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("SALES PERSON ID");
		head.add("MBRSH ID");
		head.add("ORD ID");		
		head.add("MBRSH AMT");
		head.add("IS EXCLUDE");
		head.add("RUN ID");		
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList10T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0010T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("salesPersonId").toString());
			lst.add(dataList.get(i).get("mbrshId").toString());
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("mbrshAmt").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead11T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("RCORD ID");
		head.add("ORD ID");
		head.add("SALES PERSON ID");
		head.add("INSTLMT");
		head.add("PV");
		head.add("PRC");
		head.add("ORD TYPE ID");
		head.add("IS EXCLUDE");
		head.add("BILL RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList11T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0011T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("rcordId").toString());
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("salesPersonId").toString());
			lst.add(dataList.get(i).get("instlmt").toString());
			lst.add(dataList.get(i).get("pv").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(dataList.get(i).get("ordTypeId").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runid").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead12T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("CLCTR_ID");
		head.add("ORD_ID");
		head.add("TRGET_AMT");
		head.add("COLCT_AMT");
		head.add("CUST_RACE_ID");
		head.add("RENT_PAY_MODE_ID");
		head.add("CUST_ID");
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList12T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0012T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("clctrId").toString());
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("trgetAmt").toString());
			lst.add(dataList.get(i).get("colctAmt").toString());
			lst.add(dataList.get(i).get("custRaceId").toString());
			lst.add(dataList.get(i).get("rentPayModeId").toString());
			lst.add(dataList.get(i).get("custId").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead13T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("CLCTR ID");
		head.add("ORD ID");
		head.add("STRTG OS");
		head.add("CLOS OS");
		head.add("IS DROP");
		head.add("IS EXCLUDE");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList13T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0013T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("clctrId").toString());
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("strtgOs").toString());
			lst.add(dataList.get(i).get("closOs").toString());
			lst.add(dataList.get(i).get("isDrop").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead14T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("EMPLY ID");
		head.add("SPONS ID");
		head.add("INSTLMT");
		head.add("IS EXCLUDE");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList14T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0014T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("sponsId").toString());
			lst.add(dataList.get(i).get("instlmt").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead15T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("PAY ID");
		head.add("ORD ID");
		head.add("CLCTR ID");
		head.add("AMT");
		head.add("IS EXCLUDE");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList15T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0015T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("payId").toString());
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("clctrId").toString());
			lst.add(dataList.get(i).get("amt").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead16T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("TASK_ID");
		head.add("CMMS_DT");
		head.add("C_MEM_ID");
		head.add("C_MEM_LEV");
		head.add("P_MEM_ID");
		head.add("P_MEM_LEV");
		head.add("TBB_LEV");
		head.add("CNS_UNIT");
		head.add("CNSPV_TOT");
		head.add("PNS_UNIT");
		head.add("TBB_TOT");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList16T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0016T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("taskId").toString());
			lst.add(dataList.get(i).get("cmmsDt").toString());
			lst.add(dataList.get(i).get("cMemId").toString());
			lst.add(dataList.get(i).get("cMemLev").toString());
			lst.add(dataList.get(i).get("pMemId").toString());
			lst.add(dataList.get(i).get("pMemLev").toString());
			lst.add(dataList.get(i).get("tbbLev").toString());
			lst.add(dataList.get(i).get("cnsUnit").toString());
			lst.add(dataList.get(i).get("cnspvTot").toString());
			lst.add(dataList.get(i).get("pnsUnit").toString());
			lst.add(dataList.get(i).get("tbbTot").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead17T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD_ID");
		head.add("TRGET_AMT");
		head.add("COLCT_AMT");
		head.add("MEM_CODE");
		head.add("HM_CODE");
		head.add("SM_CODE");
		head.add("GM_CODE");
		head.add("RCM_YEAR");
		head.add("RCM_MONTH");
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList17T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0017T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("trgetAmt").toString());
			lst.add(dataList.get(i).get("colctAmt").toString());
			lst.add(dataList.get(i).get("memCode").toString());
			lst.add(dataList.get(i).get("hmCode").toString());
			lst.add(dataList.get(i).get("smCode").toString());
			lst.add(dataList.get(i).get("gmCode").toString());
			lst.add(dataList.get(i).get("rcmYear").toString());
			lst.add(dataList.get(i).get("rcmMonth").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead18T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD_ID");
		head.add("INST_ID");
		head.add("STOCK_ID");
		head.add("APP_TYPE_ID");
		head.add("INST_PERSON_ID");
		head.add("PRC");
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList18T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0018T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("instId").toString());
			lst.add(dataList.get(i).get("stockId").toString());
			lst.add(dataList.get(i).get("appTypeId").toString());
			lst.add(dataList.get(i).get("instPersonId").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead19T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD_ID");
		head.add("BSR_ID");
		head.add("STOCK_ID");
		head.add("APP_TYPE_ID");
		head.add("BS_PERSON_ID");
		head.add("PRC");
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList19T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0019T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("bsrId").toString());
			lst.add(dataList.get(i).get("stockId").toString());
			lst.add(dataList.get(i).get("appTypeId").toString());
			lst.add(dataList.get(i).get("bsPersonId").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead20T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD_ID");
		head.add("AS_ENTRY_ID");
		head.add("ASR_ID");
		head.add("STOCK_ID");
		head.add("APP_TYPE_ID");
		head.add("AS_PERSON_ID");
		head.add("PRC");
		head.add("IS EXCLUDE");
		head.add("RUN_ID");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList20T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0020T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("asEntryId").toString());
			lst.add(dataList.get(i).get("asrId").toString());
			lst.add(dataList.get(i).get("stockId").toString());
			lst.add(dataList.get(i).get("appTypeId").toString());
			lst.add(dataList.get(i).get("asPersonId").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead22T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD ID");
		head.add("SRV CNTRCT ID");
		head.add("SRV CNTRCT NO");
		head.add("SALES PERSON ID");
		head.add("INSTLMT");
		head.add("PV");
		head.add("PRC");
		head.add("ORD TYPE ID");
		head.add("IS EXCLUDE");
		head.add("BILL RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList22T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0022T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("srvCntrctId").toString());
			lst.add(dataList.get(i).get("srvCntrctNo").toString());
			lst.add(dataList.get(i).get("salesPersonId").toString());
			lst.add(dataList.get(i).get("instlmt").toString());
			lst.add(dataList.get(i).get("pv").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(dataList.get(i).get("ordTypeId").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runid").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead23T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD ID");
		head.add("TRGET AMT");
		head.add("COLCT AMT");
		head.add("MEM CODE");
		head.add("HM CODE");
		head.add("SM CODE");
		head.add("GM CODE");
		head.add("RCM YEAR");
		head.add("RCM MONTH");
		head.add("SRV CNTRCT ID");
		head.add("IS EXCLUDE");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList23T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0023T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("trgetAmt").toString());
			lst.add(dataList.get(i).get("colctAmt").toString());
			lst.add(dataList.get(i).get("memCode").toString());
			lst.add(dataList.get(i).get("hmCode").toString());
			lst.add(dataList.get(i).get("smCode").toString());
			lst.add(dataList.get(i).get("gmCode").toString());
			lst.add(dataList.get(i).get("rcmYear").toString());
			lst.add(dataList.get(i).get("rcmMonth").toString());
			lst.add(dataList.get(i).get("srvCntrctId").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead25T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("EMPLY ID");
		head.add("STOCK ID");
		head.add("PROMT ID");
		head.add("PAID MONTH");
		head.add("PAID AMT");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList25T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0025T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("stockId").toString());
			lst.add(dataList.get(i).get("promtId").toString());
			lst.add(dataList.get(i).get("paidMonth").toString());
			lst.add(dataList.get(i).get("paidAmt").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	private ArrayList<String> getDataHead26T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("EMPLY ID");
		head.add("WEEK_1");
		head.add("WEEK_2");
		head.add("WEEK_3");
		head.add("WEEK_4");	
		head.add("TOT_LV");
		head.add("WEEKLY_LV");
		head.add("MONTH_LV");
		head.add("EMPLY_CODE");
		head.add("WEEKLY_LV_R");
		head.add("MONTH_LV_R");
		head.add("IS_EXCLUDE");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList26T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0026T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("week1").toString());
			lst.add(dataList.get(i).get("week2").toString());
			lst.add(dataList.get(i).get("week3").toString());
			lst.add(dataList.get(i).get("week4").toString());	
			lst.add(dataList.get(i).get("totLv").toString());
			lst.add(dataList.get(i).get("weeklyLv").toString());
			lst.add(dataList.get(i).get("monthLv").toString());
			lst.add(dataList.get(i).get("emplyCode").toString());
			lst.add(dataList.get(i).get("weeklylvr").toString());
			lst.add(dataList.get(i).get("monthLvR").toString());
			lst.add(dataList.get(i).get("isExclude").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<String> getDataHead21T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("ORD ID");
		head.add("RET ID");
		head.add("STOCK ID");
		head.add("APP TYPE ID");
		head.add("RET PERSON ID");
		head.add("PRC");
		head.add("RUN ID");
		head.add("TASK ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList21T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0021T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("ordId").toString());
			lst.add(dataList.get(i).get("retId").toString());
			lst.add(dataList.get(i).get("stockId").toString());
			lst.add(dataList.get(i).get("appTypeId").toString());
			lst.add(dataList.get(i).get("retPersonId").toString());
			lst.add(dataList.get(i).get("prc").toString());
			lst.add(dataList.get(i).get("runId").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
	private ArrayList<String> getDataHead24T(Map<String, Object> params){
		ArrayList<String> head = new ArrayList<String>();
		
		head.add("EMPLY_ID");
		head.add("EMPLY_CODE");
		head.add("PRFOM_PRCNT");
		head.add("PRFOMNC_RANK");
		head.add("TOT_EMPLY");
		head.add("CUMLT_DSTRIB");
		head.add("PAYOUT_PRCNT");
		head.add("PAYOUT_AMT");
		head.add("TASK_ID");
		
		return head;
	}
	private ArrayList<ArrayList<String>> getDataList24T(Map<String, Object> params){
		List<EgovMap> dataList = commissionCalculationService.selectCMM0024T(params);
		ArrayList<ArrayList<String>> mGroupList = new ArrayList<ArrayList<String>>();
		for(int i =0 ; i< dataList.size() ; i++){
			ArrayList<String> lst = new ArrayList<String>();
			lst.add(dataList.get(i).get("emplyId").toString());
			lst.add(dataList.get(i).get("emplyCode").toString());
			lst.add(dataList.get(i).get("prfomPrcnt").toString());
			lst.add(dataList.get(i).get("prfomncRank").toString());
			lst.add(dataList.get(i).get("totEmply").toString());
			lst.add(dataList.get(i).get("cumltDstrib").toString());
			lst.add(dataList.get(i).get("payoutPrcnt").toString());
			lst.add(dataList.get(i).get("payoutAmt").toString());
			lst.add(params.get("taskId").toString());
			mGroupList.add(lst);
		}
		return mGroupList;
	}
	
}
