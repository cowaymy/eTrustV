package com.coway.trust.biz.common;

import org.apache.ibatis.session.ResultHandler;

import com.coway.trust.web.common.claim.ClaimFileALBHandler;
import com.coway.trust.web.common.claim.ClaimFileBSNHandler;
import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcMBBHandler;
import com.coway.trust.web.common.claim.ClaimFileFPXHandler;
import com.coway.trust.web.common.claim.ClaimFileGeneralHandler;
import com.coway.trust.web.common.claim.ClaimFileHLBBHandler;
import com.coway.trust.web.common.claim.ClaimFileMBBHandler;
import com.coway.trust.web.common.claim.ClaimFileMyClearHandler;
import com.coway.trust.web.common.claim.ClaimFileNewALBHandler;
import com.coway.trust.web.common.claim.ClaimFilePBBHandler;
import com.coway.trust.web.common.claim.ClaimFileRHBHandler;
import com.coway.trust.web.common.claim.CreditCardFileCIMBHandler;
import com.coway.trust.web.common.claim.CreditCardFileMBBHandler;
import com.coway.trust.web.common.claim.ECashDeductionFileCIMBHandler;
import com.coway.trust.web.common.claim.ECashDeductionFileMBBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileCIMBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileHSBCHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileMBBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileAMBHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LargeExcelService {

  void downLoad06T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad07T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad08T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad09T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad10T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad11T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad12T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad13T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad14T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad15T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad16T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad17T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad18T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad19T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad20T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad21T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad22T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad23T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad24T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad25T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad26T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad60T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad67T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad68T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad69T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad70T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad71T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28CD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28CT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28HP(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28HT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29CD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29CT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29HP(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29HT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28TCD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28TCT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad28THP(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29TCD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29TCT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoad29THP(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadHPResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadCDResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadCMResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadCTResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadClaimFileALB(Object parameter, ClaimFileALBHandler claimFileALBHandler);

  void downLoadClaimFileNewALB(Object parameter, ClaimFileNewALBHandler claimFileNewALBHandler);

  void downLoadClaimFileCIMB(Object parameter, ClaimFileCIMBHandler claimFileCIMBHandler);

  void downLoadClaimFileHLBB(Object parameter, ClaimFileHLBBHandler claimFileHLBBHandler);

  void downLoadClaimFileMBB(Object parameter, ClaimFileMBBHandler claimFileMBBHandler);

  void downLoadClaimFilePBB(Object parameter, ClaimFilePBBHandler claimFilePBBHandler);

  void downLoadClaimFileRHB(Object parameter, ClaimFileRHBHandler claimFilePBBHandler);

  void downLoadClaimFileBSN(Object parameter, ClaimFileBSNHandler claimFileBSNHandler);

  void downLoadClaimFileMyClear(Object parameter, ClaimFileMyClearHandler claimFileMyClearHandler);

  void downLoadClaimFileCrcCIMB(Object parameter, ClaimFileCrcCIMBHandler claimFileCrcCIMBHandler);

  void downLoadClaimFileCrcMBB(Object parameter, ClaimFileCrcMBBHandler claimFileCrcMBBHandler);

  void downLoadClaimFileFPX(Object parameter, ClaimFileFPXHandler claimFileFPXHandler);

  void downloadInvcAdjExcelList(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downloadMonthlyBillRawData(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downloadDailyCollectionRawData(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadDCPMaster(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downLoadECashDeductionFileCIMB(Object parameter, ECashDeductionFileCIMBHandler downloadHandler);

  void downLoadECashDeductionFileMBB(Object parameter, ECashDeductionFileMBBHandler downloadHandler);

  void downLoadCreditCardFileCIMB(Object parameter, CreditCardFileCIMBHandler creditCardFileCIMBHandler);

  void downLoadCreditCardFileMBB(Object parameter, CreditCardFileMBBHandler creditCardFileMBBHandler);

  void downLoadECashGrpDeductionFileMBB(Object parameter, ECashGrpDeductionFileMBBHandler downloadHandler);

  void downLoadECashGrpDeductionFileCIMB(Object parameter, ECashGrpDeductionFileCIMBHandler downloadHandler);

  void downLoad(String id, Object parameter, ResultHandler excelDownloadHandler);

  void downLoadClaimFileGeneral(Object parameter, ClaimFileGeneralHandler claimFileGeneralHandler);

  void downloadCreditCardFileHSBC(Object parameter, ClaimFileGeneralHandler claimFileGeneralHandler);

  void downloadOrdPayCnvrList(Object parameter, ExcelDownloadHandler excelDownloadHandler);

  void downloadCreditCardFileAMB(Object parameter, ClaimFileGeneralHandler claimFileGeneralHandler);

  void downLoadECashGrpDeductionFileAMB(Object parameter, ECashGrpDeductionFileAMBHandler downloadHandler);

  void downLoadECashGrpDeductionFileHSBC(Object parameter,
		ECashGrpDeductionFileHSBCHandler eCashGrpDeductionFileHSBCHandler);

}
