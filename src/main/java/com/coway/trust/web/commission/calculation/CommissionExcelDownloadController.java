package com.coway.trust.web.commission.calculation;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.web.commission.CommissionConstants;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

/**
 * - 대용량 Excel 다운로드시 사용... (Use for large Excel download ...)
 */
@Controller
public class CommissionExcelDownloadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommissionExcelDownloadController.class);

	@Autowired
	private LargeExcelService largeExcelService;

	@RequestMapping("/commExcelFile.do")
	public void excelFile(HttpServletRequest request, HttpServletResponse response) {
		ExcelDownloadHandler downloadHandler = null;
		try {
			String fileName = request.getParameter("fileName");
			String codeNm = request.getParameter("code");
			String actionType = request.getParameter("actionType");
			
			String[] columns;
			String[] titles;

			int pvMonth = Integer.parseInt(request.getParameter("month").toString());
			int pvYear = Integer.parseInt(request.getParameter("year").toString());
			int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);

			Map map = new HashMap();
			map.put("taskId", sTaskID);

			if (codeNm.equals(CommissionConstants.COMIS_CTL_P01) || codeNm.equals(CommissionConstants.COMIS_CTM_P01)
					|| codeNm.equals(CommissionConstants.COMIS_CTR_P01)) {

				map.put("codeGruop", CommissionConstants.COMIS_CT);
				if (codeNm.equals(CommissionConstants.COMIS_CTR_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v1", "v2", "v3",
							"v4", "v5", "v6", "v7", "v8","totalJob", "v9", "v10", "v11", "v12", "v13", "v14" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEMBER CODE", "MEM TYPE", "AS Count",
							"AS Sum CP", "BS Count", "BS Sum CP", "Ins Count", "Ins Sum CP", "PR Count", "PR Sum CP","TOTAL JOB",
							"Total Point", "Pro Percent", "Per Percent", "Pro Factor (30%)", "Per Factor (70%)",
							"Sum Facto" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CTL_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v1", "v2", "v3",
							"v4", "v5", "v6", "v7", "v8","totalJob", "v9", "v10", "v11", "v12", "v13", "v14" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEMBER CODE", "MEM TYPE", "AS Count",
							"AS Sum CP", "BS Count", "BS Sum CP", "Ins Count", "Ins Sum CP", "PR Count", "PR Sum CP","TOTAL JOB",
							"Total Point", "Pro Percent", "Per Percent", "Pro Factor (30%)", "Per Factor (70%)",
							"Sum Facto" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CTM_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v1", "v2", "v3",
							"v4", "v5", "v6", "v7", "v8","totalJob", "v9", "v10", "v11", "v12", "v13", "v14" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEMBER CODE", "MEM TYPE", "AS Count",
							"AS Sum CP", "BS Count", "BS Sum CP", "Ins Count", "Ins Sum CP", "PR Count", "PR Sum CP","TOTAL JOB",
							"Total Point", "Pro Percent", "Per Percent", "Pro Factor (30%)", "Per Factor (70%)",
							"Sum Facto" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				}
				map.put("memberCd", request.getParameter("memberCd"));

				if((CommissionConstants.COMIS_ACTION_TYPE).equals(actionType)){
					largeExcelService.downLoad28CT(map, downloadHandler);
				}else{
					largeExcelService.downLoad28TCT(map, downloadHandler);
				}

			} else if (codeNm.equals(CommissionConstants.COMIS_CDC_P01)
					|| codeNm.equals(CommissionConstants.COMIS_CDG_P01)
					|| codeNm.equals(CommissionConstants.COMIS_CDM_P01)
					|| codeNm.equals(CommissionConstants.COMIS_CDN_P01)
					|| codeNm.equals(CommissionConstants.COMIS_CDS_P01)) {

				map.put("codeGruop", CommissionConstants.COMIS_CD);
				if (codeNm.equals(CommissionConstants.COMIS_CDC_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					map.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank",
							"v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
							"v19", "v20", "v21", "v24", "v25", "v26", "v27", "v32", "v33" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEMBER CODE", "MEM TYPE", 
							"Credit Point", "HappyCall Performance", "HappyCall Marks", "B/S Success Rate", "B/S Marks",
							"Rental Collection Rate", "Rental Collection Marks", "Net Sales Unit", "Net Sales Marks",
							"Rental Collection Amount", "Dropped Rate", "Dropped Rate  Penalty Marks",
							"Net Sales  Pv Total", "App Rate  By Total Pv", "sales price total", "Mem amount",
							"completed BS count", "pv total", "price total", "collection Cmm  applicable rate",
							"SHI rental Cmm rate", "SHI Index", "SHI rental Mem  collection rate",
							"SHI rental Mem Index", "CFF CFFCompliment", "CFF S.CFFMark" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CDN_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					map.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", "v1", "v2", "v3",
							"v4", "v5", "v6", "v7", "v8", "v9", "v10", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
							"v19", "v20", "v21", "v24", "v25", "v26", "v27" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEMBER CODE", "MEM TYPE", "Credit Point",
							"HappyCall Performance", "HappyCall Marks", "HS Success Rate", "HS Marks",
							"Rental Collection Rate", "Rental Collection Marks", "Net Sales Unit", "Net Sales Marks",
							"Rental Collection Amount", "Dropped Rate", "Dropped Rate  Penalty Marks",
							"Net Sales  Pv Total", "App Rate  By Total Pv", "sales price total", "Mem amount",
							"completed BS count", "pv total", "price total", "collection Cmm  applicable rate",
							"SHI rental Cmm rate", "SHI Index", "SHI rental Mem  collection rate",
							"SHI rental Mem Index" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CDM_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", "v1", "v2", "v3",
							"v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v16", "v17", "v18",
							"v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27", "v29", "v30", "v31" };
					titles = new String[] { "TASK ID", "RUN ID", "MEM ID", "MEM CODE", "MEM RANK",
							"performance index", "Happy Call Rate", "HappyCall Mark", "HS Rate", "HS Mark", "RC Rate", "RC Mark", "v8", "net sales marks",
							"Grp Sales Product", "Grp SalesProduct Mark", "Drop Rate", "Drop Rate PenaltyMark", "v14", "rental collection amount", "v17",
							"completed BS count", "v19", "price total", "v21", "credit point", "credit point",
							"SHI rental collection rate", "v25", "SHI rental Mem collection rate", "SHI RentMembership Index",
							"HS Productivity", "HS Productivity Mark", "v31" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CDS_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", 
							"v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v16", "v17", "v18",
							"v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27", "v29", "v30", "v31" };
					titles = new String[] { "TASK ID", "RUN ID", "MEM ID", "MEM CODE", "MEM RANK",
							"performance index", "HappyCall Rate", "HappyCall Mark", "HS Rate", "HS Mark", "RC Rate", "RC Mark", "v8", "net sales marks",
							"group sales productivity", "Grp Sales Product Mark", "Drop Rate PenaltyMark", "v13", "v14", "CollectionAmt",
							"Membership Sales Amount total", "v18", "v19", "v20", "v21", "v22", "v23",
							"SHI rental collection rate", "SHI Index", "SHI rental membership collection rate", "SHI RentMembership Index", "HS Productivity",
							"HS Productivity Mark", "v31" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				}
				map.put("memberCd", request.getParameter("memberCd"));

				if((CommissionConstants.COMIS_ACTION_TYPE).equals(actionType)){
					largeExcelService.downLoad28CD(map, downloadHandler);
				}else{
					largeExcelService.downLoad28TCD(map, downloadHandler);
				}

			} else if (codeNm.equals(CommissionConstants.COMIS_HPF_P01)
					|| codeNm.equals(CommissionConstants.COMIS_HPG_P01)
					|| codeNm.equals(CommissionConstants.COMIS_HPM_P01)
					|| codeNm.equals(CommissionConstants.COMIS_HPS_P01)
					|| codeNm.equals(CommissionConstants.COMIS_HPT_P01)) {

				map.put("codeGruop", CommissionConstants.COMIS_HP);
				if (codeNm.equals(CommissionConstants.COMIS_HPF_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank",
							"v1", "v8", "v14", "v15", "v19", "v20", "v21", "v24", "v25", "v26", "v27" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "EMPLY CODE", "MEM TYPE",
							"membership amount", "net sales unit pv total", "net sales unit pv tota",
							"applicable rate by totalpv", "pv total", "price total", "net sales pv total",
							"SHI rental collection rate", "SHI Index", "SHI rental collection rate", "SHI Index" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPG_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v1", "v8", "v9",
							"v13", "v14", "v15", "v16", "v17", "v18", "v19", "v20", "v21", "v22", "v24", "v25", "v26",
							"v27" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "EMPLY CODE", "MEM TYPE",
							"membership amount", "net sales unit pv tota", "net sales unit pv total",
							"net sales unit pv total", "net sales unit pv total", "Bonus Rate", "pv total",
							"price total", "net sales pv total", "pv total", "price total", "net sales pv total",
							"neo pro hp's number", "SHI rental collection rate", "SHI Index",
							"SHI rental collection rate", "SHI Index" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPM_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v1", "v8", "v9",
							"v13", "v14", "v15", "v16", "v17", "v18", "v19", "v20", "v21", "v22", "v24", "v25", "v26",
							"v27" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "EMPLY CODE", "MEM TYPE",
							"membership amount", "net sales unit pv total", "net sales unit pv total",
							"net sales unit pv total", "net sales unit pv total", "Bonus Rate", "pv tota",
							"price total", "net sales pv total", "pv total", "price total", "net sales pv total",
							"neo pro hp's number", "SHI rental collection rate", "SHI Index",
							"SHI rental collection rate", "SHI Index" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPS_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v1", "v8", "v9",
							"v13", "v14", "v15", "v16", "v17", "v18", "v19", "v20", "v21", "v22", "v24", "v25", "v26",
							"v27" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE",
							"membership amount", "net sales unit pv total", "net sales unit pv total",
							"net sales unit pv total", "net sales unit pv total", "Bonus Rate", "pv total",
							"price total", "net sales pv total", "pv total", "price total", "net sales pv total",
							"neo pro hp's numbe", "SHI rental collection rate", "SHI Index",
							"SHI rental collection rate", "SHI Index" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPT_P01)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "v8", "v14", "v20",
							"v28" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "EMPLY CODE", "MEM TYPE",
							"net sales unit pv total", "net sales unit pv total", "price tota", "Only Wallace" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				}
				map.put("memberCd", request.getParameter("memberCd"));

				
				if((CommissionConstants.COMIS_ACTION_TYPE).equals(actionType)){
					largeExcelService.downLoad28HP(map, downloadHandler);
				}else{
					largeExcelService.downLoad28THP(map, downloadHandler);
				}

			} else if (codeNm.equals(CommissionConstants.COMIS_CTL_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CTM_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CTR_P02)) {

				map.put("codeGruop", CommissionConstants.COMIS_CT);
				if (codeNm.equals(CommissionConstants.COMIS_CTR_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType",
							"r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "Gross Comm",
							"Rental Comm", "Srv Mem Comm", "Basic   Allowance", "Performance Incentive", "Adjustment",
							"CFF + Reward", "Seniority" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CTL_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType",
							"r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "Gross Comm",
							"Rental Comm", "Srv Mem Comm", "Basic   Allowance", "Performance Incentive", "Adjustment",
							"CFF + Reward", "Seniority" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CTM_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType",
							"r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "Gross Comm",
							"Rental Comm", "Srv Mem Comm", "Basic   Allowance", "Performance Incentive", "Adjustment",
							"CFF + Reward", "Seniority" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				}
				
				map.put("memberCd", request.getParameter("memberCd"));

				if((CommissionConstants.COMIS_ACTION_TYPE).equals(actionType)){
					largeExcelService.downLoad29CT(map, downloadHandler);
				}else{
					largeExcelService.downLoad29TCT(map, downloadHandler);
				}

			} else if (codeNm.equals(CommissionConstants.COMIS_CDC_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CDG_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CDM_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CDN_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CDS_P02)) {

				map.put("codeGruop", CommissionConstants.COMIS_CD);
				if (codeNm.equals(CommissionConstants.COMIS_CDC_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					map.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", "r1", "r2", "r3",
							"r4", "r5", "r6", "r7", "r8", "r10", "r11", "r28", "r29", "r30", "r34", "r35", "r36",
							"r38", "r39", "r99" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE",
							"performance incentive", "Personal sales Cmm", "Personal Rental Cmm", "bonus Cmm",
							"sales encouragement allowance", "rental collection Cmm", "PE Encouragement",
							"Healthy Family Fund", "newely entering allowance", "introduction fees",
							"Incentive", "SHI Amt", "r30", "Personal Rental Mem Cmm", "RentalMembership SHI_Amt", "r36",
							"COmmincentive ovr_type", "Outright Plus Personal Rental Cmm", "Adjustment" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CDN_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					map.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", "r1", "r2", "r3",
							"r4", "r5", "r6", "r7", "r8", "r10", "r11", "r28", "r29", "r30", "r34", "r35", "r36",
							"r38", "r39", "r99","r50" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE",
							"performance incentive", "Personal sales Cmm", "Personal Rental Cmm", "bonus Cmm",
							"sales encouragement allowance", "rental collection Cmm", "PE Encouragement",
							"Healthy Family Fund", "newely entering allowance", "introduction fees", "Incentive",
							"SHI Amt", "r30", "Personal Rental Mem Cmm", "RentalMembership SHI_Amt", "r36",
							"COmmincentive ovr_type", "Outright Plus Personal Rental Cmm", "Adjustment","W/S" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CDM_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", "r1", "r2", "r3",
							"r4", "r20", "r21", "r22", "r23", "r24", "r26", "r27", "r28", "r29", "r31", "r34", "r39",
							"r42", "r99" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "Per_Amt",
							"Personal sales Cmm", "Personal Rental Cmm", "Bonus Cmm",
							"performance incentive basic salary", "sales commission Overiding", "sales Cmm Overiding",
							"monthly allowance", "mobile phone allowance", "Telephone_Deduct", "Staff_Purchase",
							"Others", "SHI Amt", "r31", "Personal Rental Mem Cmm", "Outright Plus Personal Rental Cmm",
							"Outright Plus Overidding", "Adjustment" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_CDS_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "emplyCodeRank", "r1", "r2", "r3",
							"r4", "r19", "r20", "r21", "r22", "r23", "r24", "r27", "r28", "r29", "r32", "r34", "r39",
							"r41", "r42", "r99" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM RANK", "Per Amt",
							"Personal sales Cmm", "Personal Rental Cmm", "Bonus Amt", "sales Cmm",
							"performance incentive basic salary", "sales Cmm Overiding", "sales Cmm Overiding",
							"monthly allowance", "mobile phone allowance", "Staff Purchase", "Others", "SHI Amt", "r32",
							"RentalMembership Amt", "Outright Plus Personal Rental Cmm", "Outright Plus Overidding",
							"r42", "Adjustment" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				}
				map.put("memberCd", request.getParameter("memberCd"));

				if((CommissionConstants.COMIS_ACTION_TYPE).equals(actionType)){
					largeExcelService.downLoad29CD(map, downloadHandler);
				}else{
					largeExcelService.downLoad29TCD(map, downloadHandler);
				}

			} else if (codeNm.equals(CommissionConstants.COMIS_HPF_P02)
					|| codeNm.equals(CommissionConstants.COMIS_HPG_P02)
					|| codeNm.equals(CommissionConstants.COMIS_HPM_P02)
					|| codeNm.equals(CommissionConstants.COMIS_HPS_P02)
					|| codeNm.equals(CommissionConstants.COMIS_HPT_P02)
					|| codeNm.equals(CommissionConstants.COMIS_HPB_P02)) {

				map.put("codeGruop", CommissionConstants.COMIS_HP);
				if (codeNm.equals(CommissionConstants.COMIS_HPF_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "r1", "r2", "r3",
							"r4", "r5", "r13", "r18", "r19", "r22", "r25", "r28", "r29", "r30", "r34", "r35", "r36",
							"r39", "r40", "r41", "r99","r50" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE",
							"performance incentives neopro", "sales Cmm", "Personal Rental Cmm", "Bonus Cmm",
							"performance allowance", "Membership_Amt", "Sales Cmm overidding", "SM Overidding",
							"HM Overidding", "TBB_Amt", "Incentive", "SHI_Amt", "r30", "RentalMembership_Amt",
							"RentalMembership SHI_Amt", "r36", "Personal Outright Plus Cmm", "r40", "SM Overidding",
							"Adjust_Amt","W/S" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPB_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "r1", "r2", "r3",
							"r4", "r5", "r13", "r18", "r19", "r22", "r25", "r28", "r29", "r30", "r34", "r35", "r36",
							"r39", "r40", "r41", "r99" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE",
							"performance incentives neopro", "sales Cmm", "Personal Rental Cmm", "Bonus Cmm",
							"performance allowance", "Membership_Amt", "Sales Cmm overidding", "SM Overidding",
							"HM Overidding", "TBB_Amt", "Incentive", "SHI_Amt", "r30", "RentalMembership_Amt",
							"RentalMembership SHI_Amt", "r36", "Personal Outright Plus Cmm", "r40", "SM Overidding",
							"Adjust_Amt" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPG_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "r2", "r3", "r4",
							"r13", "r18", "r19", "r20", "r21", "r22", "r25", "r28", "r29", "r30", "r32", "r33", "r34",
							"r39", "r40", "r41", "r42", "r99","r50" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "sales Cmm",
							"Personal Rental Cmm", "Bonus", "Mem Amt", "Sales Cmm overidding", "SM Overidding",
							"performance incentives neopro", "sales Cmm", "HM Overidding", "TBB_Amt", "Incentive",
							"SHI_Amt", "r30", "r32", "r33", "RentalMembership Amt", "Personal Outright Plus Cmm",
							"Outright Plus Overidding", "SM Overidding", "r42", "Adjust_Amt","W/S" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPM_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "r2", "r3", "r4",
							"r13", "r18", "r19", "r21", "r22", "r25", "r28", "r29", "r30", "r31", "r34", "r39", "r40",
							"r41", "r42", "r99","r50" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "sales Cmm",
							"Personal Rental Cmm", "Bonus", "Mem Amt", "Sales Cmm overidding", "SM Overidding",
							"sales commission Overiding", "HM Overidding", "TBB_Amt", "Incentive", "SHI_Amt", "r30",
							"r31", "RentalMembership Amt", "Personal Outright Plus Cmm", "Outright Plus Overidding",
							"SM Overidding", "r42", "Adjust_Amt", "W/S" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPS_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "r2", "r33", "r99" ,"r50"};
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "sales Cmm",
							"Rental before", "Adjust_Amt" ,"W/S"};

					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				} else if (codeNm.equals(CommissionConstants.COMIS_HPT_P02)) {
					map.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
					columns = new String[] { "taskId", "runId", "emplyId", "emplyCode", "memType", "r1", "r2", "r3",
							"r4", "r5", "r13", "r18", "r19", "r20", "r21", "r22", "r25", "r28", "r29", "r30", "r31",
							"r32", "r33", "r34", "r35", "r36", "r39", "r40", "r41", "r42", "r99" };
					titles = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM CODE", "MEM TYPE", "r1", "r2", "r3",
							"Bonus", "PA", "Membership_Amt", "r18", "r19", "r20", "r21", "r22", "TBB_Amt", "Incentive",
							"SHI_Amt", "r30", "r31", "r32", "r33", "RentalMembership_Amt", "RentalMembership_SHI_Amt",
							"r36", "r39", "r40", "r41", "r42", "Adjust_Amt" };
					downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

				}
				map.put("memberCd", request.getParameter("memberCd"));

				if((CommissionConstants.COMIS_ACTION_TYPE).equals(actionType)){
					largeExcelService.downLoad29HP(map, downloadHandler);
				}else{
					largeExcelService.downLoad29THP(map, downloadHandler);
				}

			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P01)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("memberCd", request.getParameter("memberCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "deptCode", "mangrid", "memId", "emplyTypeCode", "joindt", "emplyLev",
						"emplyLevAge", "workingMonth", "sponsCode", "emplyStusId", "emplyStusCode", "emplyLevRank",
						"emplyveh", "emplyBizTypeId", "mangrcode", "emplycode", "paystus", "ishsptlz", "runId",
						"taskid", "isExclude" };
				titles = new String[] { "DEPT CODE", "MANGR ID", "MEM ID", "EMPLY TYPE CODE", "JOIN DT", "EMPLY LEV",
						"EMPLY LEV AGE", "WORKING MONTH", "SPONS CODE", "EMPLY STUS ID", "EMPLY STUS CODE",
						"EMPLY LEV RANK", "EMPLY VEH", "EMPLY BIZ TYPE ID", "MANGR CODE", "EMPLY CODE", "PAY STUS",
						"IS HSPTLZ", "RUN ID", "TASK ID", "IS EXCLUDE" };

				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad06T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P02)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("memberCd", request.getParameter("memberCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId","salesOrdNo","stkDesc", "memId", "memCode", "code", "ordTypeId", "productId", "unitValu", "prc",
						"pvValu", "runId", "taskId", "isExclude" };
				titles = new String[] { "ORD ID","SALES ORD NO","STK DESC", "MEM ID", "MEM CODE", "CODE", "ORD TYPE ID", "PRODUCT ID", "UNIT VALU", "PRC",
						"PV VALU", "RUN ID", "TASK ID", "IS EXCLUDE" };

				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad07T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P03)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("svcPersonCd", request.getParameter("svcPersonCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId","bsSchdulId", "bsrNo","svcPersonId", "emplyCode", "bsStusId", "crditPoint", "runId",
						"taskId", "isExclude" };
				titles = new String[] { "ORDER ID", "BS SCHDUL ID", "BSR NO","SVC PERSON ID", "EMPLY CODE", "BS STUS ID", "CRDIT POINT",
						"RUN ID", "TASK ID", "IS EXCLUDE" };

				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad08T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P04)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("svcPersonCd", request.getParameter("svcPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "svcPersonId", "hapyCallId", "ordId", "custRespnsId", "emplyCode", "pnctult",
						"appran", "xplnt", "qly", "overal", "runId", "taskId", "isExclude" };
				titles = new String[] { "SVC PERSON ID", "HAPY CALL ID", "ORD ID", "CUST RESPNS ID", "EMPLY CODE",
						"PNCTULT", "APPRAN", "XPLNT", "QLY", "OVERAL", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad09T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P05)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("salesPersonCd", request.getParameter("salesPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "salesPersonId", "emplyCode", "mbrshId", "ordId", "mbrshAmt", "runId",
						"taskId", "isExclude" };
				titles = new String[] { "SALES PERSON ID", "EMPLY CODE", "MBRSH ID", "ORD ID", "MBRSH AMT", "RUN ID",
						"TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad10T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P06)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("salesPersonCd", request.getParameter("salesPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "rcordId", "ordId","salesOrdNo","stkDesc", "salesPersonId", "emplyCode", "instlmt", "pv", "prc",
						"ordTypeId", "runid", "taskId", "isExclude" };
				titles = new String[] { "RCORD ID", "ORD ID","SALES ORD NO","STK DESC", "SALES PERSON ID", "EMPLY CODE", "INSTLMT", "PV", "PRC",
						"ORD TYPE ID", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad11T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P07)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("clctrCd", request.getParameter("clctrCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "clctrId", "ordId", "trgetAmt", "colctAmt", "custRaceId", "rentPayModeId",
						"custId", "emplyCode", "runId", "taskId", "isExclude" };
				titles = new String[] { "CLCTR ID", "ORD ID", "TRGET AMT", "COLCT AMT", "CUST RACE ID",
						"RENT PAY MODE ID", "CUST ID", "EMPLY CODE", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad12T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P08)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("clctrCd", request.getParameter("clctrCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "clctrId", "emplyCode", "ordId", "strtgOs", "closOs", "isDrop", "runId",
						"taskId", "isExclude" };
				titles = new String[] { "CLCTR ID", "EMPLY CODE", "ORD ID", "STRTG OS", "CLOS OS", "IS DROP", "RUN ID",
						"TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad13T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P09)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "emplyId", "emplyCode", "sponsId", "instlmt", "runId", "runId", "taskId",
						"isExclude" };
				titles = new String[] { "EMPLY ID", "EMPLY CODE", "SPONS ID", "INSTLMT", "RUN ID", "RUN ID", "TASK ID",
						"IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad14T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P010)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "payId", "ordId", "clctrId", "emplyCode", "amt", "runId", "taskId",
						"isExclude" };
				titles = new String[] { "PAY ID", "ORD ID", "CLCTR ID", "EMPLY CODE", "AMT", "RUN ID", "TASK ID",
						"IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad15T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_HPB_P01)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("pMemCd", request.getParameter("pMemCd"));

				columns = new String[] { "taskId", "cmmsDt", "cMemId", "cMemLev", "pMemId", "pMemLev", "tbbLev",
						"cnsUnit", "cnspvTot", "pnsUnit", "tbbTot", "runId", "emplyCode" };
				titles = new String[] { "TASK ID", "CMMS DT", "C MEM ID", "C MEM LEV", "P MEM ID", "P MEM LEV",
						"TBB LEV", "CNS UNIT", "CNSPV TOT", "PNS UNIT", "TBB TOT", "RUN ID", "EMPLY CODE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad16T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P011)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("memCd", request.getParameter("memCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId", "trgetAmt", "colctAmt","memId", "memCode", "hmCode", "smCode", "gmCode",
						"rcmYear", "rcmMonth", "runId", "taskId", "isExclude" };
				titles = new String[] { "ORD ID", "TRGET AMT", "COLCT AMT","MEM ID", "MEM CODE", "HM CODE", "SM CODE", "GM CODE",
						"RCM YEAR", "RCM MONTH", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad17T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P012)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("salesPersonCd", request.getParameter("salesPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId", "srvCntrctId", "srvCntrctNo", "salesPersonId", "emplyCode", "instlmt",
						"pv", "prc", "ordTypeId", "runid", "taskId", "isExclude" };
				titles = new String[] { "ORD ID", "SRV CNTRCT ID", "SRV CNTRCT NO", "SALES PERSON ID", "SALES PERSON CODE", "INSTALLMENT", 
						"PV","PRC","ORD TYPE ID","RUN ID","TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad22T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P013)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("memCode", request.getParameter("memCode"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId", "trgetAmt", "colctAmt", "memCode", "hmCode", "smCode", "gmCode",
						"rcmYear", "rcmMonth", "srvCntrctId", "runId", "taskId", "isExclude" };
				titles = new String[] { "ORD ID", "TRGET AMT", "COLCT AMT", "MEM CODE", "HM CODE", "SM CODE", "GM CODE",
						"RCM YEAR", "RCM MONTH", "SRV CNTRCT ID", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad23T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P014)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("emplyCd", request.getParameter("emplyCd"));

				columns = new String[] { "emplyId", "emplyCode", "ordId", "stockId", "promtId", "paidMonth", "paidAmt",
						"runId", "taskId" };
				titles = new String[] { "EMPLY ID", "EMPLY CODE", "ORD ID", "STOCK ID", "PROMT ID", "PAID MONTH",
						"PAID AMT", "RUN ID", "TASK ID" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad25T(map, downloadHandler);
			} else if (codeNm.equals(CommissionConstants.COMIS_BSD_P015)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "emplyTypeCode","grpName","emplyId", "emplyCode", "week1", "week2", "week3", "week4", "tot", "totLv",
						"cAward", "lAward", "cCriteria", "lCriteria", "runId", "taskId", "isExclude" };
				titles = new String[] { "GROUP CODE", "ORG NAME",  "EMPLY ID", "EMPLY CODE", "WEEK1", "WEEK2", "WEEK3", "WEEK4", "TOTAL", "TOTAL COMPLETE",
						"AWARD(THIS MONTH)", "AWARD(LAST MONTH)", "CRITERIA(THIS MONTH)", "CRITERIA(LAST MONTH)", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad26T(map, downloadHandler);
			}else if (codeNm.equals(CommissionConstants.COMIS_BSD_P016)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "emplyCode","emplyId","orgTypeCode","mRank", "qRank", "yRank", "outrgt", "instlmt", "rental", "outrightPlus", "pv",
						"tot", "pvYear", "pvMonth", "deptCode", "grpCode", "orgCode", "runId", "taskId", "isExclude" };
				titles = new String[] { "EMPLY CODE", "EMPLY ID", "ORG TYPE",  "M RANK", "Q RANK","Y RANK","OUTRGT","INSTLMT","RENTAL","OUTRIGHT PLUS","PV"
						,"TOT" ,"PV YEAR","PV MONTH","DEPT CODE","GRP CODE","ORG CODE","RUN ID","TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad60T(map, downloadHandler);
			}else if (codeNm.equals(CommissionConstants.COMIS_BSD_P017)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "grpName","emplyCode","emplyId","neoCnt", "tot", "outrgt", "instlmt", "rental", "pv", "pvYear", "pvMonth",
						"deptCode", "grpCode", "orgCode", "runId", "taskId", "isExclude" };
				titles = new String[] { "GRP NAME","EMPLY CODE","EMPLY ID","NEO CNT", "TOT", "OUTRGT", "INSTLMT", "RENTAL", "PV", "PV YEAR", "PV MONTH",
						"DEPT CODE", "GRP CODE", "ORG CODE", "run Id", "task Id", "is Exclude" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad67T(map, downloadHandler);
			}else if (codeNm.equals(CommissionConstants.COMIS_BSD_P018)) {
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "grpName","emplyCode","emplyId","tot", "outrgt", "instlmt", "rental", "pv", "pvYear", "pvMonth", "deptCode",
						"grpCode", "orgCode", "runId", "taskId", "isExclude" };
				titles = new String[] { "GRP NAME","EMPLY CODE","EMPLY ID","TOT", "OUTRGT", "INSTLMT", "RENTAL", "PV", "PV YEAR", "PV MONTH", "DEPT CODE",
						"GRP CODE", "ORG CODE", "run Id", "task Id", "is Exclude" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad68T(map, downloadHandler);
			}
			else if (codeNm.equals(CommissionConstants.COMIS_CTB_P01)) {
				map.put("ordId", request.getParameter("ordId"));
				map.put("instPersonCd", request.getParameter("instPersonCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "taskId", "ordId", "ordNo", "instId","instNo", "stockId", "stockDesc", "appTypeId","appDesc", "instPersonId",
						"emplyCode", "prc", "runId", "isExclude" };
				titles = new String[] { "TASK ID", "ORD ID","ORD NO", "INST ID", "INST NO", "STOCK ID", "STOCK DESC", "APP TYPE ID","APP TYPE DESC", "INST PERSON ID",
						"EMPLY CODE", "PRC", "RUN ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad18T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_CTB_P02)) {
				map.put("ordId", request.getParameter("ordId"));
				map.put("bsPersonCd", request.getParameter("bsPersonCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId", "bsrId", "stockId", "appTypeId", "bsPersonId", "emplyCode", "prc",
						"runId", "taskId", "isExclude" };
				titles = new String[] { "ORD ID", "BSR ID", "STOCK ID", "APP TYPE ID", "BS PERSON ID", "EMPLY CODE",
						"PRC", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad19T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_CTB_P03)) {
				map.put("ordId", request.getParameter("ordId"));
				map.put("asEntryCd", request.getParameter("asEntryCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId","ordNo", "asEntryId", "asrId","asNo", "stockId","stockDesc", "appTypeId","appDesc" ,"asPersonId",
						"emplyCode", "prc", "runId", "taskId", "isExclude" };
				titles = new String[] { "ORD ID","ORD NO" ,"AS ENTRY ID", "ASR ID", "ASR NO","STOCK ID", "STOCK DESC", "APP TYPE ID","APP TYPE DESC", "AS PERSON ID",
						"EMPLY CODE", "PRC", "RUN ID", "TASK ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad20T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_CTB_P04)) {
				map.put("ordId", request.getParameter("ordId"));
				map.put("retPCd", request.getParameter("retPCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));

				columns = new String[] { "ordId","ordNo", "retId", "retnNo","emplyCode", "stockId","stockDesc", "appTypeId","appDesc", "retPersonId", "prc",
						"taskId", "runId", "isExclude" };
				titles = new String[] { "ORD ID","ORD NO", "RET ID", "RETN NO","EMPLY CODE", "STOCK ID","STOCK DESC", "APP TYPE ID", "APP TYPE DESC","RET PERSON ID",
						"PRC", "TASK ID", "RUN ID", "IS EXCLUDE" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad21T(map, downloadHandler);

			} else if (codeNm.equals(CommissionConstants.COMIS_CTB_P05)) {
				map.put("ordId", request.getParameter("ordId"));
				map.put("emplyCd", request.getParameter("emplyCd"));

				columns = new String[] { "emplyId", "emplyCode", "prfomPrcnt", "prfomncRank", "totEmply", "cumltDstrib",
						"payoutPrcnt", "payoutAmt", "taskId" };
				titles = new String[] { "EMPLY ID", "EMPLY CODE", "PRFOM PRCNT", "PRFOMNC RANK", "TO TEMPLY",
						"CUMLT DSTRIB", "PAYOUT PRCNT", "PAYOUT AMT", "TASK ID" };
				downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);
				largeExcelService.downLoad24T(map, downloadHandler);
			} else {
				throw new ApplicationException(AppConstants.FAIL, "Invalid codeNm......");
			}

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}

	private ExcelDownloadHandler getExcelDownloadHandler(HttpServletResponse response, String fileName,
			String[] columns, String[] titles) {
		ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns, titles);
		return new ExcelDownloadHandler(excelDownloadVO, response);
	}
}
