package com.coway.trust.web.common.excel.download;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFColor;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.LargeExcelQuery;
import com.coway.trust.cmmn.exception.ApplicationException;

public class ExcelDownloadJobFactory {

	public static ExcelDownloadVO getExcelDownloadVO(String fileName, LargeExcelQuery excelQuery) {
		checkParams(fileName);

		ExcelDownloadVO excelDownloadVO = readExcelDownloadVO(excelQuery, fileName);
		return excelDownloadVO;
	}

	public static ExcelDownloadVO getExcelDownloadVO(String fileName, LargeExcelQuery excelQuery, String title) {
		checkParams(fileName);

		ExcelDownloadVO excelDownloadVO = readExcelDownloadVO(excelQuery, fileName, title);
		return excelDownloadVO;
	}

	private static void checkParams(String fileName) {
		if (StringUtils.isEmpty(fileName)) {
			throw new ApplicationException(AppConstants.FAIL, "fileName is required.!!");
		}
	}

	private static ExcelDownloadVO readExcelDownloadVO(LargeExcelQuery excelQuery, String fileName) {
		return readExcelDownloadVO(excelQuery, fileName, "");
	}

	private static ExcelDownloadVO readExcelDownloadVO(LargeExcelQuery excelQuery, String fileName, String title) {
		ExcelDownloadVO excelVo = setHeader(fileName, title);

		List<ExcelDownloadColumnVO> columns = new ArrayList<>();
		List<ExcelDownloadHeaderVO> headers = new ArrayList<>();

		excelVo.setExcelColumns(columns);
		excelVo.setExcelHeaders(headers);

		String[] columnNames;
		String[] titleNames;

		switch (excelQuery) {
    		case CMM0006T:
    			columnNames = new String[] { "deptCode", "mangrid", "memId", "emplyTypeCode", "joindt"
    					, "emplyLev", "emplyLevAge", "workingMonth", "sponsCode", "emplyStusId"
    					, "emplyStusCode", "emplyLevRank", "emplyveh", "emplyBizTypeId", "mangrcode"
    					, "emplycode", "paystus", "ishsptlz", "runId", "taskid"
    					, "isExclude"};
    			titleNames = new String[] { "DEPT CODE", "MANGR ID", "MEM ID", "EMPLY TYPE CODE", "JOIN DT"
    					, "EMPLY LEV", "EMPLY LEV AGE", "WORKING MONTH", "SPONS CODE", "EMPLY STUS ID"
    					, "EMPLY STUS CODE", "EMPLY LEV RANK", "EMPLY VEH", "EMPLY BIZ TYPE ID", "MANGR CODE"
    					, "EMPLY CODE", "PAY STUS", "IS HSPTLZ", "RUN ID", "TASK ID"
    					, "IS EXCLUDE"};
    			break;
    			
    		case CMM0007T:
    			columnNames = new String[] { "ordId", "memId", "code", "ordTypeId", "productId"
    					, "unitValu", "prc", "pvValu" , "runId", "taskId"
    					, "isExclude"};
    			titleNames = new String[] { "ORD ID", "MEM ID", "CODE", "ORD TYPE ID", "PRODUCT ID"
    					, "UNIT VALU", "PRC", "PV VALU" , "RUN ID", "TASK ID"
    					, "IS EXCLUDE"};
    			break;
    			
    		case CMM0008T:
    			columnNames = new String[] { "bsSchdulId", "svcPersonId", "emplyCode", "bsStusId", "crditPoint"
    					, "runId", "taskId", "isExclude" };
    			titleNames = new String[] { "BS SCHDUL ID", "SVC PERSON ID", "EMPLY CODE", "BS STUS ID", "CRDIT POINT"
    					, "RUN ID", "TASK ID", "IS EXCLUDE" };
    			break;
    			
    		case CMM0009T:
    			columnNames = new String[] { "svcPersonId", "hapyCallId", "ordId", "custRespnsId", "emplyCode"
    					, "pnctult", "appran", "xplnt", "qly", "overal"
    					, "runId", "taskId", "isExclude"};
    			titleNames = new String[] { "SVC PERSON ID", "HAPY CALL ID", "ORD ID", "CUST RESPNS ID", "EMPLY CODE"
    					, "PNCTULT", "APPRAN", "XPLNT", "QLY", "OVERAL"
    					, "RUN ID", "TASK ID", "IS EXCLUDE"};
    			break;
    			
    		case CMM0010T:
    			columnNames = new String[] { "salesPersonId", "emplyCode", "mbrshId", "ordId", "mbrshAmt"
    					, "runId", "taskId", "isExclude" };
    			titleNames = new String[] { "SALES PERSON ID", "EMPLY CODE", "MBRSH ID", "ORD ID", "MBRSH AMT"
    					, "RUN ID", "TASK ID", "IS EXCLUDE" };
    			break;
    			
    		case CMM0011T:
    			columnNames = new String[] { "rcordId", "ordId", "salesPersonId", "emplyCode", "instlmt"
    					, "pv", "prc", "ordTypeId", "runid", "taskId"
    					, "isExclude"};
    			titleNames = new String[] { "RCORD ID", "ORD ID", "SALES PERSON ID", "EMPLY CODE", "INSTLMT"
    					, "PV", "PRC", "ORD TYPE ID", "RUN ID", "TASK ID"
    					, "IS EXCLUDE"};
    			break;
    			
    		case CMM0012T:
    			columnNames = new String[] { "clctrId", "ordId", "trgetAmt", "colctAmt", "custRaceId"
    					, "rentPayModeId", "custId", "emplyCode", "runId", "taskId"
    					, "isExclude"};
    			titleNames = new String[] { "CLCTR ID", "ORD ID", "TRGET AMT", "COLCT AMT", "CUST RACE ID"
    					, "RENT PAY MODE ID", "CUST ID", "EMPLY CODE", "RUN ID", "TASK ID"
    					, "IS EXCLUDE"};
    			break;
			
			case CMM0013T:
				columnNames = new String[] { "clctrId", "emplyCode", "ordId", "strtgOs", "closOs"
						, "isDrop", "runId", "taskId", "isExclude" };
				titleNames = new String[] { "CLCTR ID", "EMPLY CODE", "ORD ID", "STRTG OS", "CLOS OS"
						, "IS DROP", "RUN ID", "TASK ID", "IS EXCLUDE" };
				break;
				
			case CMM0014T:
				columnNames = new String[] { "emplyId", "emplyCode", "sponsId", "instlmt", "runId"
						, "runId", "taskId", "isExclude"};
				titleNames = new String[] { "EMPLY ID", "EMPLY CODE", "SPONS ID", "INSTLMT", "RUN ID"
						, "RUN ID", "TASK ID", "IS EXCLUDE"};
				break;
				
			case CMM0015T:
				columnNames = new String[] { "payId", "ordId", "clctrId", "emplyCode", "amt"
						, "runId", "taskId", "isExclude" };
				titleNames = new String[] { "PAY ID", "ORD ID", "CLCTR ID", "EMPLY CODE", "AMT"
						, "RUN ID", "TASK ID", "IS EXCLUDE" };
				break;
				
			case CMM0016T:
				columnNames = new String[] { "taskId", "cmmsDt", "cMemId", "cMemLev", "pMemId"
						, "pMemLev", "tbbLev", "cnsUnit", "cnspvTot", "pnsUnit"
						, "tbbTot", "runId", "emplyCode"};
				titleNames = new String[] { "TASK ID", "CMMS DT", "C MEM ID", "C MEM LEV", "P MEM ID"
						, "P MEM LEV", "TBB LEV", "CNS UNIT", "CNSPV TOT", "PNS UNIT"
						, "TBB TOT", "RUN ID", "EMPLY CODE"};
				break;
				
			case CMM0017T:
				columnNames = new String[] { "ordId", "trgetAmt", "colctAmt", "memCode", "hmCode"
						, "smCode", "gmCode", "rcmYear", "rcmMonth", "runId"
						, "taskId", "isExclude"};
				titleNames = new String[] { "ORD ID", "TRGET AMT", "COLCT AMT", "MEM CODE", "HM CODE"
						, "SM CODE", "GM CODE", "RCM YEAR", "RCM MONTH", "RUN ID"
						, "TASK ID", "IS EXCLUDE"};
				break;
				
			case CMM0018T:
				columnNames = new String[] { "taskId", "ordId", "instId", "stockId", "appTypeId"
						, "instPersonId", "emplyCode", "prc", "runId", "isExclude" };
				titleNames = new String[] { "TASK ID", "ORD ID", "INST ID", "STOCK ID", "APP TYPE ID"
						, "INST PERSON ID", "EMPLY CODE", "PRC", "RUN ID", "IS EXCLUDE" };
				break;
				
			case CMM0019T:
				columnNames = new String[] { "ordId", "bsrId", "stockId", "appTypeId", "bsPersonId"
						, "emplyCode", "prc", "runId", "taskId", "isExclude" };
				titleNames = new String[] { "ORD ID", "BSR ID", "STOCK ID", "APP TYPE ID", "BS PERSON ID"
						, "EMPLY CODE", "PRC", "RUN ID", "TASK ID", "IS EXCLUDE" };
				break;
				
			case CMM0020T:
				columnNames = new String[] { "ordId", "asEntryId", "asrId", "stockId", "appTypeId"
						, "asPersonId", "emplyCode", "prc", "runId", "taskId"
						, "isExclude"};
				titleNames = new String[] { "ORD ID", "AS ENTRY ID", "ASR ID", "STOCK ID", "APP TYPE ID"
						, "AS PERSON ID", "EMPLY CODE", "PRC", "RUN ID", "TASK ID"
						, "IS EXCLUDE"};
				break;
				
			case CMM0021T:
				columnNames = new String[] { "ordId", "retId", "emplyCode", "stockId", "appTypeId"
						, "retPersonId", "prc", "taskId", "runId", "isExclude" };
				titleNames = new String[] { "ORD ID", "RET ID", "EMPLY CODE", "STOCK ID", "APP TYPE ID"
						, "RET PERSON ID", "PRC", "TASK ID", "RUN ID", "IS EXCLUDE" };
				break;
				
			case CMM0022T:
				columnNames = new String[] { "ordId", "srvCntrctId", "srvCntrctNo", "salesPersonId", "emplyCode"
						, "instlmt", "pv", "prc", "ordTypeId", "runid"
						, "taskId", "isExclude"};
				titleNames = new String[] { "CLCTR ID", "ORD ID", "STRTG OS", "CLOS OS", "IS DROP", "IS EXCLUDE", "RUN ID", "TASK ID" };
				break;
				
			case CMM0023T:
				columnNames = new String[] { "ordId", "trgetAmt", "colctAmt", "memCode", "hmCode"
						, "smCode", "gmCode", "rcmYear", "rcmMonth", "srvCntrctId"
						, "runId", "taskId", "isExclude"};
				titleNames = new String[] { "ORD ID", "TRGET AMT", "COLCT AMT", "MEM CODE", "HM CODE"
						, "SM CODE", "GM CODE", "RCM YEAR", "RCM MONTH", "SRV CNTRCT ID"
						, "RUN ID", "TASK ID", "IS EXCLUDE"};
				break;
				
			case CMM0024T:
				columnNames = new String[] { "emplyId", "emplyCode", "prfomPrcnt", "prfomncRank", "totEmply"
						, "cumltDstrib", "payoutPrcnt", "payoutAmt", "taskId"};
				titleNames = new String[] { "EMPLY ID", "EMPLY CODE", "PRFOM PRCNT", "PRFOMNC RANK", "TO TEMPLY"
						, "CUMLT DSTRIB", "PAYOUT PRCNT", "PAYOUT AMT", "TASK ID"};
				break;
				
			case CMM0025T:
				columnNames = new String[] { "emplyId", "emplyCode", "ordId", "stockId", "promtId"
						, "paidMonth", "paidAmt", "runId", "taskId"};
				titleNames = new String[] { "EMPLY ID", "EMPLY CODE", "ORD ID", "STOCK ID", "PROMT ID"
						, "PAID MONTH", "PAID AMT", "RUN ID", "TASK ID"};
				break;
				
			case CMM0026T:
				columnNames = new String[] { "emplyId", "emplyCode", "week1", "week2", "week3"
						, "week4", "week5", "totLv", "weeklyLv", "monthLv"
						, "weeklylvr", "monthLvR", "runId", "taskId", "isExclude"};
				titleNames = new String[] { "EMPLY ID", "EMPLY CODE", "WEEK1", "WEEK2", "WEEK3"
						, "WEEK4", "WEEK5", "TOT LV", "WEEKLY LV", "MONTH LV"
						, "WEEKLY LV R", "MONTH LV R", "RUN ID", "TASK ID", "IS EXCLUDE"};
				break;
				
			case CMM0028CT:
				columnNames = new String[] { "taskId", "runId", "emplyId", "memType", "memType"
						, "v1", "v2", "v3", "v4", "v5"
						, "v6", "v7", "v8", "v9", "v10"
						, "v11", "v12", "v13", "v14"};
				titleNames = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM TYPE", "MEM TYPE"
						, "V1", "V2", "V3", "V4", "V5"
						, "V6", "V7", "V8", "V9", "V10"
						, "V11", "V12", "V13", "V14"};
				break;
				
			case CMM0028CD:
				columnNames = new String[] { "taskId", "runId", "emplyId", "memType", "memType"
						, "v1", "v2", "v3", "v4", "v5"
						, "v6", "v7", "v8", "v9", "v10"
						, "v11", "v12", "v13", "v14", "v15"
						, "v16", "v17", "v18", "v19", "v20"
						, "v21", "v22", "v23", "v24", "v25"
						, "v26", "v27", "v29", "v30", "v31"
						, "v32", "v33"};
				titleNames = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM TYPE", "MEM TYPE"
						, "V1", "V2", "V3", "V4", "V5"
						, "V6", "V7", "V8", "V9", "V10"
						, "V11", "V12", "V13", "V14", "V15"
						, "V16", "V17", "V18", "V19", "V20"
						, "V21", "V22", "V23", "V24", "V25"
						, "V26", "V27", "V29", "V30", "V31"
						, "V32", "V33"};
				break;
				
			case CMM0028HP:
				columnNames = new String[] { "taskId", "runId", "emplyId", "memType", "memType"
						, "v1", "v8", "v9", "v13", "v14"
						, "v15", "v16", "v17", "v18", "v19"
						, "v20", "v21", "v22", "v24", "v25"
						, "v26", "v27", "v28"};
				titleNames = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM TYPE", "MEM TYPE"
						, "V1", "V8", "V9", "V13", "V14"
						, "V15", "V16", "V17", "V18", "V19"
						, "V20", "V21", "V22", "V24", "V25"
						, "V26", "V27", "V28"};
				break;
				
			case CMM0029CT:
				columnNames = new String[] { "taskId", "runId", "emplyId", "memType", "memType"
						, "r1", "r2", "r3", "r4", "r5"
						, "r6", "r7", "r8"};
				titleNames = new String[] { "TASK ID", "RUN ID", "EMPLY ID", "MEM TYPE", "MEM TYPE"
						, "R1", "R2", "R3", "R4", "R5"
						, "R6", "R7", "R8"};
				break;
				
			case CMM0029CD:
				columnNames = new String[] { "taskId", "runId", "emplyId", "memType", "memType"
						, "r1", "r2", "r3", "r4", "r5"
						, "r6", "r7", "r8", "r10", "r11"
						, "r13", "r18", "r19", "r20", "r21"
						, "r22", "r23", "r24", "r26", "r27"
						, "r28", "r29", "r30", "r31", "r32"
						, "r33", "r34", "r35", "r36", "r38"
						, "r39", "r40", "r41", "r42", "r99"};
				titleNames = new String[] {"TASK ID", "RUN ID", "EMPLY ID", "MEM TYPE", "MEM TYPE"
						, "R1", "R2", "R3", "R4", "R5"
						, "R6", "R7", "R8", "R10", "R11"
						, "R13", "R18", "R19", "R20", "R21"
						, "R22", "R23", "R24", "R26", "R27"
						, "R28", "R29", "R30", "R31", "R32"
						, "R33", "R34", "R35", "R36", "R38"
						, "R39", "R40", "R41", "R42", "R99"};
				break;
				
			case CMM0029HP:
				columnNames = new String[] { "taskId", "runId", "emplyId", "memType", "memType"
						, "r1", "r2", "r3", "r4", "r5"
						, "r13", "r18", "r19", "r20", "r21"
						, "r22", "r25", "r28", "r29", "r30"
						, "r31", "r32", "r33", "r34", "r35"
						, "r36", "r39", "r40", "r41", "r42"
						, "r99"};
				titleNames = new String[] {"TASK ID", "RUN ID", "EMPLY ID", "MEM TYPE", "MEM TYPE"
						, "R1", "R2", "R3", "R4", "R5"
						, "R13", "R18", "R19", "R20", "R21"
						, "R22", "R25", "R28", "R29", "R30"
						, "R31", "R32", "R33", "R34", "R35"
						, "R36", "R39", "R40", "R41", "R42"
						, "R99"};
				break;
				
		default:
			throw new ApplicationException(AppConstants.FAIL, "Invalid JobCode");
		}

		setColumnInfo(columns, headers, columnNames, titleNames);

		return excelVo;
	}

	private static void setColumnInfo(List<ExcelDownloadColumnVO> columns, List<ExcelDownloadHeaderVO> headers,
			String[] columnNames, String[] titleNames) {
		ExcelDownloadColumnVO excelColumnVo;
		ExcelDownloadHeaderVO excelHeaderVo;

		if (columnNames.length != titleNames.length) {
			throw new ApplicationException(AppConstants.FAIL,
					"wrong parameter.....[columnNames.length != titleNames.length]");
		}

		for (String name : columnNames) {
			excelColumnVo = new ExcelDownloadColumnVO();
			excelColumnVo.setColumnName(name);
			columns.add(excelColumnVo);
		}

		int idx = 0;

		for (String titleName : titleNames) {
			excelHeaderVo = new ExcelDownloadHeaderVO();
			excelHeaderVo.setTitleName(titleName);
			// 병합이 필요하다면 구현 필요.
			excelHeaderVo.setRowColumnInfo(0, 1, idx, 1);
			headers.add(excelHeaderVo);
			idx++;
		}
	}

	private static ExcelDownloadVO setHeader(String fileName, String title) {
		return setHeader(fileName, title, "Arial", (short) 20);
	}

	private static ExcelDownloadVO setHeader(String fileName, String title, String font, short fontSize) {
		ExcelDownloadVO excelVo = new ExcelDownloadVO();
		excelVo.setExcelFilename(fileName);
		excelVo.setForegroundColor(new XSSFColor(new Color(220, 220, 220)));

		excelVo.setTitle(title);
		excelVo.setTitleFont(font);
		excelVo.setTitleFontSize(fontSize);
		return excelVo;
	}
}
