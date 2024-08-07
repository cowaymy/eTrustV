package com.coway.trust.biz.common;

import java.util.HashMap;
import java.util.Map;

public enum LargeExcelQuery {

	CMM0006T("selectCMM0006T"), CMM0007T("selectCMM0007T"), CMM0008T("selectCMM0008T"), CMM0009T("selectCMM0009T"), CMM0010T("selectCMM0010T"),
	CMM0011T("selectCMM0011T"), CMM0012T("selectCMM0012T"), CMM0013T("selectCMM0013T"), CMM0014T("selectCMM0014T"), CMM0015T("selectCMM0015T"),
	CMM0016T("selectCMM0016T"), CMM0017T("selectCMM0017T"), CMM0018T("selectCMM0018T"), CMM0019T("selectCMM0019T"), CMM0020T("selectCMM0020T"),
	CMM0021T("selectCMM0021T"), CMM0022T("selectCMM0022T"), CMM0023T("selectCMM0023T"), CMM0024T("selectCMM0024T"), CMM0025T("selectCMM0025T"),
	CMM0026T("selectCMM0026T"), CMM0060T("selectCMM0060T"), CMM0067T("selectCMM0067T"), CMM0068T("selectCMM0068T"), CMM0069T("selectCMM0069T"),
	CMM0070T("selectCMM0070T"), CMM0071T("selectCMM0071T")
	, CMM0028CD("selectCMM0028DCD"), CMM0028CT("selectCMM0028DCT"), CMM0028HP("selectCMM0028DHP")
	, CMM0029CD("selectCMM0029DCD"), CMM0029CT("selectCMM0029DCT"), CMM0029HP("selectCMM0029DHP")
	, CMM0028TCD("selectCMM0028TCD"), CMM0028TCT("selectCMM0028TCT"), CMM0028THP("selectCMM0028THP")
	, CMM0029TCD("selectCMM0029TCD"), CMM0029TCT("selectCMM0029TCT"), CMM0029THP("selectCMM0029THP")
	// Added for HT Commission by Hui Ding, 10-12-2020
	, CMM0028HT("selectCMM0028DHT"), CMM0029HT("selectCMM0029DHT")
	, RESULTINDEX_HP("selectHPRawData"), RESULTINDEX_CM("selectCMRawData"), RESULTINDEX_CD("selectCodyRawData"), RESULTINDEX_CT("selectCTRawData")

	, CLAIM_DETAIL("selectClaimDetailById"), CLAIM_DETAIL_PAGING("selectClaimDetailByIdPaging"), INVOICE_SUMMARY("selectInvoiceAdjList"),ALLDCPMASTER("selectAllDCPMaster")
	, CLAIM_DETAIL_PAGING_MBB("selectClaimDetailByIdPagingMBB")
	, ECASHDEDUCTION_DETAIL_PAGING("selectECashDeductSubByIdPaging"),ECASHDEDUCTION_DETAIL_PAGING_MBB("selectECashDeductSubByIdPagingMBB"),ECASHDEDUCTION_GROUP_PAGING("selectECashGrpDeductByIdPaging")
	, DAILY_COLLECTION_RAW("selectDailyCollectionData")
	, CREDITCARD_DETAIL_PAGING("selectCreditCardDetailByIdPaging")
	, MONTHLY_BILL_RAW("selectMonthlyRawData")
	, PAY_CNVR_LIST("selectOrdPayCnvrList");

/*    // LaiKW - 20220418 - Added for CMS API
    , CMS_CNTC_API("selectCmsCntcByPaging");*/


	private final String queryId;

	LargeExcelQuery(String queryId) {
		this.queryId = queryId;
	}

	public String getQueryId() {
		return this.queryId;
	}

	private static final Map<String, LargeExcelQuery> LOOKUP = new HashMap<>();

	static {
		for (LargeExcelQuery largeExcelQuery : LargeExcelQuery.values()) {
			LOOKUP.put(largeExcelQuery.getQueryId(), largeExcelQuery);
		}
	}

	public static LargeExcelQuery get(String queryId) {
		return LOOKUP.get(queryId);
	}
}
