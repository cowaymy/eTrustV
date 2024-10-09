package com.coway.trust.biz.common.impl;

import org.apache.ibatis.session.ResultHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.LargeExcelQuery;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.web.common.claim.ClaimFileALBHandler;
import com.coway.trust.web.common.claim.ClaimFileBSNHandler;
import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcDetExcelHandler;
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
import com.coway.trust.web.common.claim.ECashGrpDeductionFileAMBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileCIMBHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileHSBCHandler;
import com.coway.trust.web.common.claim.ECashGrpDeductionFileMBBHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service
public class LargeExcelServiceImpl implements LargeExcelService {

	@Autowired
	private ExcelDownloadMapper excelDownloadMapper;

	@Override
	public void downLoad06T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0006T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad07T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0007T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad08T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0008T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad09T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0009T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad10T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0010T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad11T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0011T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad12T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0012T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad13T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0013T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad14T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0014T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad15T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0015T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad16T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0016T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad17T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0017T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad18T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0018T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad19T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0019T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad20T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0020T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad21T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0021T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad22T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0022T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad23T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0023T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad24T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0024T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad25T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0025T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad26T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0026T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad60T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0060T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad67T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0067T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad68T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0068T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad69T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0069T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad70T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0070T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad71T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0071T.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28CD(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028CD.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28CT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028CT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28HP(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028HP.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28HT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028HT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29CD(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029CD.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29CT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029CT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29HP(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029HP.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29HT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029HT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28TCD(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028TCD.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28TCT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028TCT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad28THP(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0028THP.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29TCD(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029TCD.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29TCT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029TCT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad29THP(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.CMM0029THP.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoadHPResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.RESULTINDEX_HP.getQueryId(), parameter, excelDownloadHandler);
	}
	@Override
	public void downLoadCDResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.RESULTINDEX_CD.getQueryId(), parameter, excelDownloadHandler);
	}
	@Override
	public void downLoadCMResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.RESULTINDEX_CM.getQueryId(), parameter, excelDownloadHandler);
	}
	@Override
	public void downLoadCTResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.RESULTINDEX_CT.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoadDCPMaster(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.ALLDCPMASTER.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoadClaimFileALB(Object parameter, ClaimFileALBHandler claimFileALBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileALBHandler);
	}

	@Override
	public void downLoadClaimFileNewALB(Object parameter, ClaimFileNewALBHandler claimFileNewALBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileNewALBHandler);
	}

	@Override
	public void downLoadClaimFileCIMB(Object parameter, ClaimFileCIMBHandler claimFileCIMBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileCIMBHandler);
	}

	@Override
	public void downLoadClaimFileHLBB(Object parameter, ClaimFileHLBBHandler claimFileHLBBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileHLBBHandler);
	}

	@Override
	public void downLoadClaimFileMBB(Object parameter, ClaimFileMBBHandler claimFileMBBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileMBBHandler);
	}

	@Override
	public void downLoadClaimFilePBB(Object parameter, ClaimFilePBBHandler claimFilePBBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFilePBBHandler);
	}

	@Override
	public void downLoadClaimFileRHB(Object parameter, ClaimFileRHBHandler claimFileRHBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileRHBHandler);
	}

	@Override
	public void downLoadClaimFileBSN(Object parameter, ClaimFileBSNHandler claimFileBSNHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileBSNHandler);
	}

	@Override
	public void downLoadClaimFileMyClear(Object parameter, ClaimFileMyClearHandler claimFileMyClearHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileMyClearHandler);
	}

	@Override
	public void downLoadClaimFileCrcCIMB(Object parameter, ClaimFileCrcCIMBHandler claimFileCrcCIMBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL_PAGING.getQueryId(), parameter, claimFileCrcCIMBHandler);
	}

	@Override
	public void downLoadClaimFileCrcMBB(Object parameter, ClaimFileCrcMBBHandler claimFileCrcMBBHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL_PAGING_MBB.getQueryId(), parameter, claimFileCrcMBBHandler);
	}

	@Override
	public void downLoadClaimFileFPX(Object parameter, ClaimFileFPXHandler claimFileFPXHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileFPXHandler);
	}

	@Override
	public void downloadInvcAdjExcelList(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.INVOICE_SUMMARY.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downloadMonthlyBillRawData(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.MONTHLY_BILL_RAW.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downloadDailyCollectionRawData(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad(LargeExcelQuery.DAILY_COLLECTION_RAW.getQueryId(), parameter, excelDownloadHandler);
	}

	@Override
	public void downLoadECashDeductionFileCIMB(Object parameter, ECashDeductionFileCIMBHandler eCashDeductionFileCIMBHandler) {
		this.downLoad(LargeExcelQuery.ECASHDEDUCTION_DETAIL_PAGING.getQueryId(), parameter, eCashDeductionFileCIMBHandler);
	}

	@Override
	public void downLoadECashDeductionFileMBB(Object parameter, ECashDeductionFileMBBHandler eCashDeductionFileMBBHandler) {
		this.downLoad(LargeExcelQuery.ECASHDEDUCTION_DETAIL_PAGING_MBB.getQueryId(), parameter, eCashDeductionFileMBBHandler);
	}

	@Override
	public void downLoadCreditCardFileCIMB(Object parameter, CreditCardFileCIMBHandler creditCardFileCIMBHandler) {
		this.downLoad(LargeExcelQuery.CREDITCARD_DETAIL_PAGING.getQueryId(), parameter, creditCardFileCIMBHandler);
	}

	@Override
	public void downLoadCreditCardFileMBB(Object parameter, CreditCardFileMBBHandler creditCardFileMBBHandler) {
		this.downLoad(LargeExcelQuery.CREDITCARD_DETAIL_PAGING.getQueryId(), parameter, creditCardFileMBBHandler);
	}

	@Override
	public void downLoadECashGrpDeductionFileMBB(Object parameter, ECashGrpDeductionFileMBBHandler eCashGrpDeductionFileMBBHandler) {
		this.downLoad(LargeExcelQuery.ECASHDEDUCTION_GROUP_PAGING.getQueryId(), parameter, eCashGrpDeductionFileMBBHandler);
	}

	@Override
	public void downLoadECashGrpDeductionFileCIMB(Object parameter, ECashGrpDeductionFileCIMBHandler eCashGrpDeductionFileCIMBHandler) {
		this.downLoad(LargeExcelQuery.ECASHDEDUCTION_GROUP_PAGING.getQueryId(), parameter, eCashGrpDeductionFileCIMBHandler);
	}

	@Override
	public void downLoad(String id, Object parameter, ResultHandler resultHandler) {
		excelDownloadMapper.getSqlSession().select(id, parameter, resultHandler);
	}

	@Override
	public void downLoadClaimFileGeneral(Object parameter, ClaimFileGeneralHandler claimFileGeneralHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_DETAIL.getQueryId(), parameter, claimFileGeneralHandler);
	}

	@Override
    public void downloadCreditCardFileHSBC(Object parameter, ClaimFileGeneralHandler claimFileGeneralHandler) {
        this.downLoad(LargeExcelQuery.CREDITCARD_DETAIL_PAGING.getQueryId(), parameter, claimFileGeneralHandler);
    }

    @Override
    public void downloadOrdPayCnvrList(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
        this.downLoad(LargeExcelQuery.PAY_CNVR_LIST.getQueryId(), parameter, excelDownloadHandler);
    }

  @Override
  public void downloadCreditCardFileAMB(Object parameter, ClaimFileGeneralHandler claimFileGeneralHandler) {
      this.downLoad(LargeExcelQuery.CREDITCARD_DETAIL_PAGING.getQueryId(), parameter, claimFileGeneralHandler);
  }

  @Override
  public void downLoadECashGrpDeductionFileAMB(Object parameter, ECashGrpDeductionFileAMBHandler eCashGrpDeductionFileAMBHandler) {
    this.downLoad(LargeExcelQuery.ECASHDEDUCTION_GROUP_PAGING.getQueryId(), parameter, eCashGrpDeductionFileAMBHandler);
  }

  @Override
  public void downLoadECashGrpDeductionFileHSBC(Object parameter, ECashGrpDeductionFileHSBCHandler eCashGrpDeductionFileHSBCHandler) {
    this.downLoad(LargeExcelQuery.ECASHDEDUCTION_GROUP_PAGING.getQueryId(), parameter, eCashGrpDeductionFileHSBCHandler);
  }

  @Override
	public void downLoadClaimFileExcel(Object parameter, ClaimFileCrcDetExcelHandler claimFileExcelHandler) {
		this.downLoad(LargeExcelQuery.CLAIM_EXCEL.getQueryId(), parameter, claimFileExcelHandler);
	}
}
