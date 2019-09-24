package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("invoiceAdjService")
public class InvoiceAdjServiceImpl extends EgovAbstractServiceImpl implements InvoiceAdjService{

	@Resource(name = "invoiceAdjMapper")
	private InvoiceAdjMapper invoiceMapper;

	@Resource(name = "webInvoiceMapper")
    private WebInvoiceMapper webInvoiceMapper;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<EgovMap> selectInvoiceAdj(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectInvoiceAdjList(params);
	}

	@Override
	public List<EgovMap> selectNewAdjMaster(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectNewAdjMaster(params);
	}

	@Override
	public List<EgovMap> selectNewAdjDetailList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectNewAdjDetailList(params);
	}


	/**
	 * Adjustment CN/DN AccID  조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap getAdjustmentCnDnAccId(Map<String, Object> params){
		return invoiceMapper.getAdjustmentCnDnAccId(params);
	}


    /**
	 * Adjustment CN/DN request  등록
	 * @param params
	 * @return
	 */
	@Override
	public String saveNewAdjList(boolean isBatch, int adjustmentType , Map<String, Object> masterParamMap, List<Object> detailParamList, List<Object> apprGridList){

		int memoAdjustmentId = invoiceMapper.getAdjustmentId();
		String reportNo = commonMapper.selectDocNo("18");

		String adjustmentNo = "";
		if(adjustmentType == 1293){
			adjustmentNo = commonMapper.selectDocNo("134");
		}else{
			adjustmentNo = commonMapper.selectDocNo("135");
		}

		//마스터 정보 등록
		masterParamMap.put("memoAdjustId", memoAdjustmentId);
		masterParamMap.put("memoAdjustRefNo", adjustmentNo);
		masterParamMap.put("memoAdjustReportNo", reportNo);

		invoiceMapper.saveNewAdjMaster(masterParamMap);

		//배치 등록일 경우 배치 정보를 입력한다.
		if(isBatch){
			invoiceMapper.saveBatchInfo(masterParamMap);
		}

		//Detail Data 등로
    	if (detailParamList.size() > 0) {
    		HashMap<String, Object> hm = null;
    		for (Object map : detailParamList) {
    			hm = (HashMap<String, Object>) map;

    			hm.put("memoAdjustId", memoAdjustmentId);
    			invoiceMapper.saveNewAdjDetail(hm);
    		}
    	}

    	//히스토리 정보 등록
    	invoiceMapper.saveNewAdjHist(masterParamMap);

    	// 2019-09-11 - LaiKW - New Adjustment Approval insert
    	if(apprGridList != null) {
    	    if(apprGridList.size() > 0) {
                HashMap<String, Object> hm = null;
                for(Object map : apprGridList) {
                    hm = (HashMap<String, Object>) map;

                    hm.put("memoAdjustId", memoAdjustmentId);
                    hm.put("memoAdjustRefNo", adjustmentNo);
                    hm.put("userName", masterParamMap.get("memoAdjustCreatorName"));
                    hm.put("userId", masterParamMap.get("memoAdjustCreator"));

                    if("1".equals(hm.get("approveNo").toString())) {
                        hm.put("appvStus", "R");

                        String nextApprover = invoiceMapper.nextApprover(hm);

                        // insert notification
                        Map ntf = new HashMap<String, Object>();
                        ntf.put("code", "New Adj");
                        ntf.put("codeName", "CN/DN Adjustment");
                        ntf.put("clmNo", adjustmentNo);
                        ntf.put("appvStus", "R");
                        ntf.put("rejctResn", "Pending Approval.");
                        ntf.put("reqstUserId", nextApprover);
                        ntf.put("userId", masterParamMap.get("memoAdjustCreator"));

                        webInvoiceMapper.insertNotification(ntf);
                    } else {
                        hm.put("appvStus", "T");
                    }

                    invoiceMapper.insertAdjReqAppv(hm);
                }
            }
    	}

    	return adjustmentNo + " / " + reportNo;
	}

	@Override
	public void insertNotification(Map<String, Object> params) {
	    webInvoiceMapper.insertNotification(params);
	}

	@Override
    public EgovMap getFinApprover() {
        return invoiceMapper.getFinApprover();
    }

	@Override
	public void insertAdjReqAppv(Map<String, Object> params) {
	    invoiceMapper.insertAdjReqAppv(params);
	}

	/**
	 * Adjustment Batch ID 채번
	 * @param params
	 * @return
	 */
	@Override
	public int getAdjBatchId(){
		return invoiceMapper.getAdjBatchId();
	}

	/**
	 * Adjustment CN/DN Detail Pop-up Master 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectAdjDetailPopMaster(Map<String, Object> params){
		return invoiceMapper.selectAdjDetailPopMaster(params);
	}

	/**
	 * Adjustment CN/DN Detail Pop-up Detail List 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAdjDetailPopList(Map<String, Object> params) {
		return invoiceMapper.selectAdjDetailPopList(params);
	}

	/**
	 * Adjustment CN/DN Detail Pop-up History 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAdjDetailPopHist(Map<String, Object> params) {
		return invoiceMapper.selectAdjDetailPopHist(params);
	}

	@Override
	public void updateAdjApprovalLine(Map<String, Object> params) {
	    invoiceMapper.updateAdjApprovalLine(params);
	}

	@Override
    public void updateAdjNextAppvLine(Map<String, Object> params) {
        invoiceMapper.updateAdjNextAppvLine(params);
    }

	/**
	* Approval Adjustment  - Approva / Reject
	* @param params
	* @param model
	* @return
	*/
	@Override
	public void approvalAdjustment(Map<String, Object> params) {
		int status = "APPROVE".equals(String.valueOf(params.get("process"))) ? 4 : 21;
		int invoiceType = Integer.parseInt(String.valueOf(params.get("invoiceType")));
		params.put("status", status);

		//상태값 변경
		invoiceMapper.approvalAdjustmentMaster(params);
		invoiceMapper.approvalAdjustmentDetails(params);

		//히스토리 정보 등록
		HashMap<String, Object> historyMap = new HashMap<String, Object>();

		historyMap.put("memoAdjustInvoiceNo", params.get("invoiceNo"));
		historyMap.put("memoAdjustId", params.get("adjId"));
		historyMap.put("memoAdjustStatusID", status);
		historyMap.put("memoAdjustCreator", params.get("userId"));

    	invoiceMapper.saveNewAdjHist(historyMap);

    	//invoiceMapper.updateAdjApprovalLine(params);

    	// If batch - Last sequence only proceed

		//승인 처리시 데이터 처리
		if(status == 4){
			if(invoiceType == 126){			//Rental
				//데이터 처리를 위한 마스터 정보 조회 : Rental
				int noteId = invoiceMapper.getNoteId();
				EgovMap masterData = invoiceMapper.selectAdjMasterForApprovalRental(params);

				masterData.put("noteId", noteId);
				masterData.put("noteTypeId", params.get("memoAdjTypeId"));
				masterData.put("userId", params.get("userId"));

				//마스터 정보 등록(PAY0027D)
				invoiceMapper.insertAccTaxDebitCreditNote(masterData);

				//데이터 처리를 위한 상세 정보 조회 : Rental
				List<EgovMap> detailDataList = invoiceMapper.selectAdjDetailsForApprovalRental(params);
				HashMap<String, Object> ledgerMap = null;

				for (EgovMap obj : detailDataList) {
					//상세 정보 등록(PAY0028D)
					obj.put("noteId", noteId);
					invoiceMapper.insertAccTaxDebitCreditNoteSub(obj);

					if("134".equals(String.valueOf(obj.get("noteBillTypeId")))){
						ledgerMap = new HashMap<String, Object>();
						ledgerMap.put("srvSalesOrdId", obj.get("noteItmOrdId"));
						ledgerMap.put("srvLdgrCntrctId", obj.get("noteItmSrvCntrctId"));
						ledgerMap.put("srvLdgrRefNo", masterData.get("noteRefNo"));

						if("1293".equals(String.valueOf(params.get("memoAdjTypeId")))){
							ledgerMap.put("srvLdgrTypeId", 155);
							ledgerMap.put("srvLdgrAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt")))  * -1.0  );
						}else{
							ledgerMap.put("srvLdgrTypeId", 157);
							ledgerMap.put("srvLdgrAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))));
						}

						ledgerMap.put("srvLdgrCntrctSchdulId", 0);
						ledgerMap.put("srvLdgrCntrctSchdulNo", 0);
						ledgerMap.put("srvLdgrRem", "");
						ledgerMap.put("userId", params.get("userId"));

						if("1317".equals(String.valueOf(obj.get("noteTypeId")))){
							ledgerMap.put("srvLdgrPayType", 1305);
						}else{
							ledgerMap.put("srvLdgrPayType", 1307);
						}

						//service contract ledger 등록(PAY0023D)
						invoiceMapper.insertAccServiceContractLedger(ledgerMap);

					}else{
						ledgerMap = new HashMap<String, Object>();
						ledgerMap.put("rentSoId", obj.get("noteItmOrdId"));
						ledgerMap.put("rentDocNo", masterData.get("noteRefNo"));

						if("1293".equals(String.valueOf(params.get("memoAdjTypeId")))){
							ledgerMap.put("rentDocTypeId", 155);
							ledgerMap.put("rentAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt")))  * -1.0  );
						}else{
							ledgerMap.put("rentDocTypeId", 157);
							ledgerMap.put("rentAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))));
						}

						ledgerMap.put("rentInstNo", 0);
						ledgerMap.put("rentBatchNo", "0");
						ledgerMap.put("userId", params.get("userId"));

						//Rent ledger 등록(PAY0022D)
						invoiceMapper.insertAccRentLedger(ledgerMap);
					}
				}
			} else if(invoiceType == 127){			//Outright

				//데이터 처리를 위한 마스터 정보 조회 : Outright
				int noteId = invoiceMapper.getNoteId();
				EgovMap masterData = invoiceMapper.selectAdjMasterForApprovalOutright(params);

				masterData.put("noteId", noteId);
				masterData.put("noteTypeId", params.get("memoAdjTypeId"));
				masterData.put("userId", params.get("userId"));

				//마스터 정보 등록(PAY0027D)
				invoiceMapper.insertAccTaxDebitCreditNote(masterData);

				//데이터 처리를 위한 상세 정보 조회 : Rental
				List<EgovMap> detailDataList = invoiceMapper.selectAdjDetailsForApprovalOutright(params);
				HashMap<String, Object> ledgerMap = null;

				for (EgovMap obj : detailDataList) {
					//상세 정보 등록(PAY0028D)
					obj.put("noteId", noteId);
					invoiceMapper.insertAccTaxDebitCreditNoteSub(obj);

					//Trade ledger 등록(PAY0035D)
					ledgerMap = new HashMap<String, Object>();

					ledgerMap.put("tradeSoId", obj.get("noteItmOrdId"));
					ledgerMap.put("tradeDocNo", masterData.get("noteRefNo"));

					if("1293".equals(String.valueOf(params.get("memoAdjTypeId")))){
						ledgerMap.put("tradeDocTypeId", 155);
						ledgerMap.put("tradeAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt")))  * -1.0  );
					}else{
						ledgerMap.put("tradeDocTypeId", 157);
						ledgerMap.put("tradeAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))));
					}

					ledgerMap.put("tradeBatchNo", "0");
					ledgerMap.put("tradeInstNo", 0);
					ledgerMap.put("userId", params.get("userId"));

					//Trade ledger 등록(PAY0035D)
					invoiceMapper.insertAccTradeLedger(ledgerMap);
				}

			} else if(invoiceType == 128){			//Misc
				//데이터 처리를 위한 마스터 정보 조회 : Outright
				int noteId = invoiceMapper.getNoteId();
				EgovMap masterData = invoiceMapper.selectAdjMasterForApprovalMisc(params);

				masterData.put("noteId", noteId);
				masterData.put("noteTypeId", params.get("memoAdjTypeId"));
				masterData.put("userId", params.get("userId"));

				//마스터 정보 등록(PAY0027D)
				invoiceMapper.insertAccTaxDebitCreditNote(masterData);

				//데이터 처리를 위한 상세 정보 조회 : Rental
				List<EgovMap> detailDataList = invoiceMapper.selectAdjDetailsForApprovalMisc(params);
				HashMap<String, Object> ledgerMap = null;

				for (EgovMap obj : detailDataList) {
					//상세 정보 등록(PAY0028D)
					obj.put("noteId", noteId);
					invoiceMapper.insertAccTaxDebitCreditNoteSub(obj);

					if("1261".equals(String.valueOf(obj.get("noteItmTypeId"))) || "1262".equals(String.valueOf(obj.get("noteItmTypeId")))){
						//AS
						ledgerMap = new HashMap<String, Object>();
						ledgerMap.put("asDocNo", masterData.get("noteRefNo"));

						if("1293".equals(String.valueOf(params.get("memoAdjTypeId")))){
							ledgerMap.put("asLgDocTypeId", 155);
							ledgerMap.put("asLgAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt")))  * -1.0  );
						}else{
							ledgerMap.put("asLgDocTypeId", 157);
							ledgerMap.put("asLgAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))));
						}

						ledgerMap.put("asSoNo", obj.get("noteItmOrdNo"));
						ledgerMap.put("asSoId", obj.get("noteItmOrdId"));
						ledgerMap.put("asResultNo", masterData.get("noteGrpNo"));
						ledgerMap.put("userId", params.get("userId"));

						//AS ledger 등록(PAY0006D)
						invoiceMapper.insertASLedger(ledgerMap);

					}else if("1265".equals(String.valueOf(obj.get("noteItmTypeId"))) || "1266".equals(String.valueOf(obj.get("noteItmTypeId")))){

						//Service Membership
						String quotNo = (obj.get("noteDesc2") == null || "".equals(String.valueOf(obj.get("noteDesc2")))) ? String.valueOf(masterData.get("noteGrpNo")) : String.valueOf(obj.get("noteDesc2")) ;
						int quotId = invoiceMapper.selectQuotId(quotNo);
						int srvMemId =  invoiceMapper.selectSrvMemId(quotId);

						//Service Membership ledger 데이터 세팅
						ledgerMap = new HashMap<String, Object>();

						ledgerMap.put("srvMemId", srvMemId);
						ledgerMap.put("srvMemDocNo", masterData.get("noteRefNo"));

						if("1293".equals(String.valueOf(params.get("memoAdjTypeId")))){
							ledgerMap.put("srvMemDocTypeId", 155);
							ledgerMap.put("srvMemAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt")))  * -1.0  );
						}else{
							ledgerMap.put("srvMemDocTypeId", 157);
							ledgerMap.put("srvMemAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))));
						}

						ledgerMap.put("srvMemInstNo", 0);
						ledgerMap.put("srvMemBatchNo", "0");
						ledgerMap.put("userId", params.get("userId"));

						//Service Membership ledger 등록(PAY0024D)
						invoiceMapper.insertAccSrvMemLedger(ledgerMap);

					} else if ("1276".equals(String.valueOf(obj.get("noteItmTypeId"))) || "1274".equals(String.valueOf(obj.get("noteItmTypeId")))){
						// Early Termination  || Product Lost Charges
						ledgerMap = new HashMap<String, Object>();
						ledgerMap.put("rentSoId", obj.get("noteItmOrdId"));
						ledgerMap.put("rentDocNo", masterData.get("noteRefNo"));

						if("1293".equals(String.valueOf(params.get("memoAdjTypeId")))){
							ledgerMap.put("rentDocTypeId", 155);
							ledgerMap.put("rentAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt")))  * -1.0  );
						}else{
							ledgerMap.put("rentDocTypeId", 157);
							ledgerMap.put("rentAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))));
						}

						ledgerMap.put("rentInstNo", 0);
						ledgerMap.put("rentBatchNo", "0");
						ledgerMap.put("userId", params.get("userId"));

						//Rent ledger 등록(PAY0022D)
						invoiceMapper.insertAccRentLedger(ledgerMap);
					}
				}
			}
		} // end of if(status == 4)
	}

	/**
	 * Adjustment CN/DN Batch Approval Pop-up Master 조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectAdjBatchApprovalPopMaster(Map<String, Object> params){
		return invoiceMapper.selectAdjBatchApprovalPopMaster(params);
	}

	/**
	 * Adjustment CN/DN Batch Approval Pop-up Detail 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAdjBatchApprovalPopDetail(Map<String, Object> params){
		return invoiceMapper.selectAdjBatchApprovalPopDetail(params);
	}

	/**
	 * Adjustment CN/DN Batch Approval Pop-up History 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAdjBatchApprovalPopHist(Map<String, Object> params) {
		return invoiceMapper.selectAdjBatchApprovalPopHist(params);
	}

	/**
	 *
	 * @param params
	 * @return
	 */
	@Override
	public int countAdjustmentExcelList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.countAdjustmentExcelList(params);
	}

	@Override
	public EgovMap selectAdjDetailPopMasterOld(Map<String, Object> params){
		return invoiceMapper.selectAdjDetailPopMasterOld(params);
	}

	@Override
	public List<EgovMap> selectAdjDetailPopListOld(Map<String, Object> params) {
		return invoiceMapper.selectAdjDetailPopListOld(params);
	}

	@Override
    public EgovMap getAdjApprLine(Map<String, Object> params) {
        return invoiceMapper.getAdjApprLine(params);
    }

	@Override
    public List<EgovMap> selectAppvLineInfo(Map<String, Object> params) {
        // TODO Auto-generated method stub
        return invoiceMapper.selectAppvLineInfo(params);
    }

	@Override
	public String nextApprover(Map<String, Object> params) {
	    return invoiceMapper.nextApprover(params);
	}
}
