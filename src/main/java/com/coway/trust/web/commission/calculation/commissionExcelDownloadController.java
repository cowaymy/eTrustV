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
import com.coway.trust.biz.common.LargeExcelQuery;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.web.commission.CommissionConstants;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadJobFactory;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

/**
 * - 대용량 Excel 다운로드시 사용... (Use for large Excel download ...)
 */
@Controller
public class commissionExcelDownloadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(commissionExcelDownloadController.class);

	@Autowired
	private LargeExcelService largeExcelService;

	@RequestMapping("/commExcelFile.do")
	public void excelFile(HttpServletRequest request, HttpServletResponse response) {
		ExcelDownloadHandler excelDownloadHandler = null;
		try {
			String fileName = request.getParameter("fileName");
			String codeNm = request.getParameter("code");

			// 임시로 세팅...
			//fileName = "test22222222222222222.xlsx";
			// 임시로 세팅...

			int pvMonth = Integer.parseInt(request.getParameter("month").toString());
			int pvYear = Integer.parseInt(request.getParameter("year").toString());
			int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);
			
			Map map = new HashMap();
			map.put("taskId", sTaskID);
			
			if(codeNm.equals(CommissionConstants.COMIS_CTL_P01) || codeNm.equals(CommissionConstants.COMIS_CTM_P01) 
					|| codeNm.equals(CommissionConstants.COMIS_CTW_P01)){
				map.put("codeGruop", CommissionConstants.COMIS_CT);
				if(codeNm.equals(CommissionConstants.COMIS_CTW_P01))
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CTL_P01))
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CTM_P01))
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
				map.put("memberId", request.getParameter("memberId"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0028CT);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad28CT(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_CDC_P01) || codeNm.equals(CommissionConstants.COMIS_CDG_P01) 
					|| codeNm.equals(CommissionConstants.COMIS_CDM_P01)|| codeNm.equals(CommissionConstants.COMIS_CDN_P01)
					|| codeNm.equals(CommissionConstants.COMIS_CDS_P01)){
				map.put("codeGruop", CommissionConstants.COMIS_CD);
				if(codeNm.equals(CommissionConstants.COMIS_CDC_P01) || codeNm.equals(CommissionConstants.COMIS_CDN_P01))
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CDM_P01))
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CDS_P01))
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
				map.put("memberId", request.getParameter("memberId"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0028CD);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad28CD(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_HPF_P01) || codeNm.equals(CommissionConstants.COMIS_HPG_P01) 
					|| codeNm.equals(CommissionConstants.COMIS_HPM_P01)|| codeNm.equals(CommissionConstants.COMIS_HPS_P01)
					|| codeNm.equals(CommissionConstants.COMIS_HPT_P01)){
				map.put("codeGruop", CommissionConstants.COMIS_HP);
				if(codeNm.equals(CommissionConstants.COMIS_HPF_P01))
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPG_P01))
					map.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPM_P01))
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPS_P01))
					map.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPT_P01))
					map.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
				map.put("memberId", request.getParameter("memberId"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0028HP);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad28HP(map, excelDownloadHandler);
				
			}
			if(codeNm.equals(CommissionConstants.COMIS_CTL_P02) || codeNm.equals(CommissionConstants.COMIS_CTM_P02) 
					|| codeNm.equals(CommissionConstants.COMIS_CTW_P02)){
				map.put("codeGruop", CommissionConstants.COMIS_CT);
				if(codeNm.equals(CommissionConstants.COMIS_CTW_P02))
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CTL_P02))
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CTM_P02))
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
				map.put("memberId", request.getParameter("memberId"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0029CT);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad29CT(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_CDC_P02) || codeNm.equals(CommissionConstants.COMIS_CDG_P02) 
					|| codeNm.equals(CommissionConstants.COMIS_CDM_P02)|| codeNm.equals(CommissionConstants.COMIS_CDN_P02)
					|| codeNm.equals(CommissionConstants.COMIS_CDS_P02)){
				map.put("codeGruop", CommissionConstants.COMIS_CD);
				if(codeNm.equals(CommissionConstants.COMIS_CDC_P02) || codeNm.equals(CommissionConstants.COMIS_CDN_P02))
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CDM_P02))
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_CDS_P02))
					map.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
				map.put("memberId", request.getParameter("memberId"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0029CD);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad29CD(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_HPF_P02) || codeNm.equals(CommissionConstants.COMIS_HPG_P02) 
					|| codeNm.equals(CommissionConstants.COMIS_HPM_P02)|| codeNm.equals(CommissionConstants.COMIS_HPS_P02)
					|| codeNm.equals(CommissionConstants.COMIS_HPT_P02) || codeNm.equals(CommissionConstants.COMIS_HPB_P02)){
				map.put("codeGruop", CommissionConstants.COMIS_HP);
				if(codeNm.equals(CommissionConstants.COMIS_HPF_P02) || codeNm.equals(CommissionConstants.COMIS_HPB_P02))
					map.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPG_P02))
					map.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPM_P02))
					map.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPS_P02))
					map.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
				if(codeNm.equals(CommissionConstants.COMIS_HPT_P02))
					map.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
				map.put("memberId", request.getParameter("memberId"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0029HP);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad29HP(map, excelDownloadHandler);
			}else
			if(codeNm.equals(CommissionConstants.COMIS_BSD_P01)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("memberId", request.getParameter("memberId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0006T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad06T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P02)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("memberId", request.getParameter("memberId"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0007T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad07T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P03)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("svcPersonCd", request.getParameter("svcPersonCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0008T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad08T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P04)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("svcPersonCd", request.getParameter("svcPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0009T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad09T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P05)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("salesPersonCd", request.getParameter("salesPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0010T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad10T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P06)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("salesPersonCd", request.getParameter("salesPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0011T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad11T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P07)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("clctrCd", request.getParameter("clctrCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0012T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad12T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P08)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("clctrCd", request.getParameter("clctrCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0013T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad13T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P09)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("coemplyCddeId", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0014T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad14T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P010)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0015T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad15T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_HPB_P01)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("pMemCd", request.getParameter("pMemCd"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0016T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad16T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P011)){
				map.put("ordId", request.getParameter("ordId"));
				map.put("memCd", request.getParameter("memCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0017T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad17T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P012)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("salesPersonCd", request.getParameter("salesPersonCd"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0022T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad22T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P013)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("memCode", request.getParameter("memCode"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0023T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad23T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P014)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("ordId", request.getParameter("ordId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0025T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad25T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_BSD_P015)){
				map.put("codeId", request.getParameter("codeId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0026T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad11T(map, excelDownloadHandler);
			}else if(codeNm.equals(CommissionConstants.COMIS_CTB_P01)){
				map.put("ordId", request.getParameter("ordId"));
				map.put("instPersonCd", request.getParameter("instPersonCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0018T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad18T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_CTB_P02)){
				map.put("ordId", request.getParameter("ordId"));
				map.put("bsPersonCd", request.getParameter("bsPersonCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0019T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad19T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_CTB_P03)){
				map.put("ordId", request.getParameter("ordId"));
				map.put("asEntryCd", request.getParameter("asEntryCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0020T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad20T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_CTB_P04)){
				map.put("ordId", request.getParameter("ordId"));
				map.put("retPCd", request.getParameter("retPCd"));
				map.put("useYnCombo", request.getParameter("useYnCombo"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0021T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad21T(map, excelDownloadHandler);
				
			}else if(codeNm.equals(CommissionConstants.COMIS_CTB_P05)){
				map.put("ordId", request.getParameter("ordId"));
				map.put("emplyCd", request.getParameter("emplyCd"));
				
				ExcelDownloadVO excelDownloadVO = ExcelDownloadJobFactory.getExcelDownloadVO(fileName,
						LargeExcelQuery.CMM0024T);
				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
				largeExcelService.downLoad24T(map, excelDownloadHandler);
			}
			
			
			
			
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (excelDownloadHandler != null) {
				try {
					excelDownloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}
}
