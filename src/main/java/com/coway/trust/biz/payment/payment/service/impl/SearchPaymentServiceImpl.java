package com.coway.trust.biz.payment.payment.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.PayDVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByOrganizationVO;
import com.coway.trust.biz.payment.payment.service.SearchPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("searchPaymentService")
public class SearchPaymentServiceImpl extends EgovAbstractServiceImpl implements SearchPaymentService {

	@Resource(name = "searchPaymentMapper")
	private SearchPaymentMapper searchPaymentMapper;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectOrderList(Map<String, Object> params) {

	  if(    ! "".equals(CommonUtils.nvl(params.get("chequeNo")))
	      || ! "".equals(CommonUtils.nvl(params.get("crcNo")))
	      || ! "".equals(CommonUtils.nvl(params.get("bankAccount")))){
	    List<EgovMap> list =  searchPaymentMapper.getPayIdByType(params);

	    List<String> payList = new ArrayList<String>();
	    payList.add("0"); // Add PayID = 0
	    for(EgovMap item:list){
	      payList.add(item.get("payId").toString());
	    }
	    String[] payIdList = payList.stream().toArray(String[]::new);
	    params.put("payIdList", payIdList);
	  }

	  return searchPaymentMapper.selectOrderList(params);
	}

	@Override
	public List<EgovMap> selectOrderList_OrNo(Map<String, Object> params) {

	  if(    ! "".equals(CommonUtils.nvl(params.get("chequeNo")))
	      || ! "".equals(CommonUtils.nvl(params.get("crcNo")))
	      || ! "".equals(CommonUtils.nvl(params.get("bankAccount")))){
	    List<EgovMap> list =  searchPaymentMapper.getPayIdByType(params);

	    List<String> payList = new ArrayList<String>();
	    payList.add("0"); // Add PayID = 0
	    for(EgovMap item:list){
	      payList.add(item.get("payId").toString());
	    }
	    String[] payIdList = payList.stream().toArray(String[]::new);
	    params.put("payIdList", payIdList);
	  }

	  return searchPaymentMapper.selectOrderList_OrNo(params);
	}

	@Override
	public List<EgovMap> selectOrderList_aNoOrNo(Map<String, Object> params) {

	  return searchPaymentMapper.selectOrderList_aNoOrNo(params);
	}

	/**
	 * SearchPayment Order List(Master Grid) 전체 건수
	 * @param params
	 * @return
	 */
	@Override
	public int selectOrderListCount(Map<String, Object> params) {
		return searchPaymentMapper.selectOrderListCount(params);
	}

	/**
	 * SearchPayment Payment List(Slave Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentList(Map<String, Object> params) {
		return searchPaymentMapper.selectPaymentList(params);
	}

	@Override
	public String selectPayItmAmt(Map<String, Object> params) {
		return searchPaymentMapper.selectPayItmAmt(params);
	}

	@Override
	public List<EgovMap> selectPayIdFromPayItemId(Map<String, Object> params) {
		return searchPaymentMapper.selectPayIdFromPayItemId(params);
	}

	@Override
	public List<EgovMap> selectPayId(Map<String, Object> params) {
		return searchPaymentMapper.selectPayId(params);
	}

	/**
	 * Sales List(Slave Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectSalesList(Map<String, Object> params) {
		return searchPaymentMapper.selectSalesList(params);
	}

	/**
	 * RentalCollectionByBS 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<RentalCollectionByBSSearchVO> searchRentalCollectionByBSList(RentalCollectionByBSSearchVO searchVO) {
		return searchPaymentMapper.searchRentalCollectionByBSList(searchVO);
	}

	/**
     * RentalCollectionByBS 조회
     * @param params
     * @return
     */
    @Override
    public List<RentalCollectionByBSSearchVO> searchRentalCollectionByBSNewList(RentalCollectionByBSSearchVO searchVO) {
        return searchPaymentMapper.searchRentalCollectionByBSNewList(searchVO);
    }

	/**
	 * SearchMaster 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectViewHistoryList(int payId) {
		return searchPaymentMapper.selectViewHistoryList(payId);
	}

	/**
	 * SearchDetail 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectDetailHistoryList(int payItemId) {
		return searchPaymentMapper.selectDetailHistoryList(payItemId);
	}

	/**
	 * PaymentDetailViewer   조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectPaymentDetailViewer(Map<String, Object> params) {
		return searchPaymentMapper.selectPaymentDetailViewer(params);
	}

	/**
	 * 주문진행상태   조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectOrderProgressStatus(Map<String, Object> params) {
		return searchPaymentMapper.selectOrderProgressStatus(params);
	}

	/**
	 * paymentDetailView   조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentDetailView(Map<String, Object> params) {
		return searchPaymentMapper.selectPaymentDetailView(params);
	}

	/**
	 * PaymentDetailSlaveList   조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentDetailSlaveList(Map<String, Object> params) {
		return searchPaymentMapper.selectPaymentDetailSlaveList(params);
	}

	/**
	 * PaymentItem 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentItem(Map<String, Object> params) {
		return searchPaymentMapper.selectPaymentItem(params);
	}

	/**
	 * PaymentDetail 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentDetail(int payItemId) {
		// TODO Auto-generated method stub
		return searchPaymentMapper.selectPaymentDetail(payItemId);
	}

	@Override
	public String selectBankCode(String payItmIssuBankId) {
		// TODO Auto-generated method stub
		return commonMapper.selectBankInfoById(payItmIssuBankId);
	}

	@Override
	public String selectCodeDetail(int payItmCcTypeId) {
		// TODO Auto-generated method stub
		return commonMapper.codeNameById(payItmCcTypeId);
	}

	/**
	 * selectPayMaster   조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectPayMaster(Map<String, Object> params) {
		return searchPaymentMapper.selectPayMaster(params);
	}

	/**
	 *  EDIT 히스토리테이블 인서트
	 * @param params
	 * @return
	 */
	@Override
	public void saveChanges(Map<String, Object> params) {
		searchPaymentMapper.saveChanges(params);
	}

	/**
	 * EDIT 업데이트
	 * @param params
	 * @return
	 */
	@Override
	public void updChanges(Map<String, Object> params) {
		searchPaymentMapper.updChanges(params);
	}

	/**
	 * selectMemCode   조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectMemCode(Map<String, Object> params) {
		return searchPaymentMapper.selectMemCode(params);
	}

	/**
	 * selectBranchCode   조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectBranchCode(Map<String, Object> params) {
		return searchPaymentMapper.selectBranchCode(params);
	}

	/**
	 * AORType 조회
	 * @param String
	 * @return
	 */
	@Override
	public String checkORNoIsAORType(String payItem) {
		// TODO Auto-generated method stub
		return searchPaymentMapper.checkORNoIsAORType(payItem);
	}

	/**
	 * PaymentDetail 저장 및 업데이트
	 * @param PayDVO
	 * @return boolean
	 */
	@Override
	@Transactional
	public boolean doEditPaymentDetails(PayDVO payDet){

		EgovMap qryDet = selectPaymentDetail(payDet.getPayItemId()).get(0);

		List<PayDHistoryVO> list = setHistoryList(payDet, qryDet);

		//INSERT HISTORY
		if(list.size() > 0){
			for(int i=0; i<list.size(); i++){
				searchPaymentMapper.insertPayDHistory(list.get(i));
			}
		}


		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("payItemId", qryDet.get("payItmId"));

		String refNo = String.valueOf(qryDet.get("payItmRefNo")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmRefNo")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmRefNo")).trim();
		if(!(refNo.equals(payDet.getPayItemRefNo()))){
			//System.out.println("refNo : " + refNo + ", getPayItemRefNo : " + payDet.getPayItemRefNo());
			map.put("payItemRefNo", payDet.getPayItemRefNo());
		}

		String issuedBank = String.valueOf(qryDet.get("payItmIssuBankId")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmIssuBankId")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmIssuBankId")).trim();
		if(!(issuedBank.equals(String.valueOf(payDet.getPayItemIssuedBankId())))){
			//System.out.println("issuedBank : " + issuedBank + ", getPayItemIssuedBankId() : " + payDet.getPayItemIssuedBankId());
			map.put("payItemIssuedBankId", payDet.getPayItemIssuedBankId());
		}

		String tempDate = String.valueOf(qryDet.get("payItmRefDt")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmRefDt")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmRefDt")).trim();
		String refDate = "";
		if(!(tempDate.equals("")) && !(tempDate.equals("null"))){
			refDate = tempDate.split(" ")[0];
		}else{
			refDate = "1900-01-01";
		}

		String payDate = "";

		System.out.println("tempDate == " + tempDate);
		System.out.println("refDate == " + refDate);
		System.out.println("payDet.getPayItemRefDate() == " + payDet.getPayItemRefDate());

		if(!(payDet.getPayItemRefDate().equals("")) && !(payDet.getPayItemRefDate().equals("null"))){
    		String temp[] = payDet.getPayItemRefDate().split("/");
    		//payDate = temp[2] + "-" + temp[1] + "-" + temp[0];
    		payDate = temp[0] + "/" + temp[1] + "/" + temp[2];
		}else{
			payDate = "1900-01-01";
		}

		Date rDate = null;
		Date pDate = null;
		long diffDate = -1;
		try {
			rDate = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault(Locale.Category.FORMAT)).parse(refDate);
			pDate = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault(Locale.Category.FORMAT)).parse(payDate);

			long diff = rDate.getTime() - pDate.getTime();
			diffDate = diff / (24 * 60 * 60 * 1000);
		} catch(Exception ex) {
			ex.printStackTrace();
		}

		/*if(CommonUtils.getDiffDate(refDate, payDate, "YYYY-MM-DD") != 0){
			map.put("payItemRefDate", payDate);
		}*/

		if(diffDate != 0) {
			map.put("payItemRefDate", payDate);
		}

		String remark = String.valueOf(qryDet.get("payItmRem")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmRem")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmRem")).trim();
		if(!(remark.equals(payDet.getPayItemRemark()))){
			map.put("payItemRemark", payDet.getPayItemRemark());
		}

		String cCHolderName = String.valueOf(qryDet.get("payItmCcHolderName")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmCcHolderName")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmCcHolderName")).trim();
		if(!(cCHolderName.equals(payDet.getPayItemCCHolderName()))){
			map.put("payItemCCHolderName", payDet.getPayItemCCHolderName());
		}

		String cCExpiryDate = String.valueOf(qryDet.get("payItmCcExprDt")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmCcExprDt")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmCcExprDt")).trim();
		if(!(cCExpiryDate.equals(payDet.getPayItemCCExpiryDate()))){
			//System.out.println("cCExpiryDate : " + cCExpiryDate + ", pay : " + payDet.getPayItemCCExpiryDate());
			map.put("payItemCCExpiryDate", payDet.getPayItemCCExpiryDate());
		}

		String cCTypeId = String.valueOf(qryDet.get("payItmCcTypeId")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmCcTypeId")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmCcTypeId")).trim();
		if(!(cCTypeId.equals(String.valueOf(payDet.getPayItemCCTypeId())))){
			map.put("payItemCCTypeId", payDet.getPayItemCCTypeId());
		}

		String eFTNo = String.valueOf(qryDet.get("payItmEftNo")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmEftNo")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmEftNo")).trim();
		if(!(eFTNo.equals(payDet.getPayItemEFTNo()))){
			map.put("payItemEFTNo", payDet.getPayItemEFTNo());
		}

		String runningNo = String.valueOf(qryDet.get("payItmRunngNo")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmRunngNo")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmRunngNo")).trim();
		if(!(runningNo.equals(payDet.getPayItemRunningNo()))){
			map.put("payItemRunningNo", payDet.getPayItemRunningNo());
		}

		String cardTypeId = String.valueOf(qryDet.get("payItmCardTypeId")).trim().equals("null")
				|| String.valueOf(qryDet.get("payItmCardTypeId")).trim().equals("") ? "" : String.valueOf(qryDet.get("payItmCardTypeId")).trim();
		if(!(cardTypeId.equals(String.valueOf(payDet.getPayItemCardTypeId())))){
			map.put("payItemCardTypeId", payDet.getPayItemCardTypeId());
		}

		map.put("updated", CommonUtils.getNowDate());

		String userId = String.valueOf(qryDet.get("updUserId")).trim().equals("null")
				|| String.valueOf(qryDet.get("updUserId")).trim().equals("") ? "" : String.valueOf(qryDet.get("updUserId")).trim();
		if(!(userId.equals(payDet.getUpdator()))){
			map.put("updator", payDet.getUpdator());
		}

		searchPaymentMapper.updatePayDetail(map);

		//Type이 107일 경우 Update
		if(String.valueOf(qryDet.get("payItmModeId")).equals("107")){
			int payItemId = Integer.parseInt(String.valueOf(payDet.getPayItemId()));
			List<EgovMap> tmpRelated = searchPaymentMapper.selectPaymentDocRelated(payItemId);
			if(tmpRelated.size() > 0){
				EgovMap qryRelated = tmpRelated.get(0);
				List<EgovMap> tmpDocDet = searchPaymentMapper.selectPaymentDocDetail(Integer.parseInt(String.valueOf(qryRelated.get("itmId"))));
				if(tmpDocDet.size() > 0){
					EgovMap qryDocDet = tmpDocDet.get(0);

					Map<String, Object> docDet = new HashMap<String, Object>();
					docDet.put("itemId", String.valueOf(qryDocDet.get("itmId")));

					String docRefNo = String.valueOf(qryDocDet.get("refNo")).trim().equals("null")
							|| String.valueOf(qryDocDet.get("refNo")).trim().equals("") ? "" : String.valueOf(qryDocDet.get("refNo")).trim();
					if(!(docRefNo.equals(payDet.getPayItemRefNo()))){
						docDet.put("refNo", payDet.getPayItemRefNo());
					}

					String docBankId = String.valueOf(qryDocDet.get("bankId")).trim().equals("null")
							|| String.valueOf(qryDocDet.get("bankId")).trim().equals("") ? "" : String.valueOf(qryDocDet.get("bankId")).trim();
					if(!(docBankId.equals(payDet.getPayItemIssuedBankId()))){
						docDet.put("bankId", payDet.getPayItemIssuedBankId());
					}

					String tmpDate = String.valueOf(qryDocDet.get("refDt")).trim().equals("null")
							|| String.valueOf(qryDocDet.get("refDt")).trim().equals("") ? "" : String.valueOf(qryDocDet.get("refDt")).trim();
					String docRefDate = "";
					if(!(tmpDate.equals("")) && !(tmpDate.equals("null"))){
						docRefDate = tmpDate.split(" ")[0];
					}
					String docPayDate = "";
					if(!(payDet.getPayItemRefDate().equals("")) && !(payDet.getPayItemRefDate().equals("null"))){
			    		String temp[] = payDet.getPayItemRefDate().split("/");
			    		docPayDate = temp[2] + "-" + temp[1] + "-" + temp[0];
					}else{
						docPayDate = "1900-01-01";
					}
					if(CommonUtils.getDiffDate(docRefDate, docPayDate, "YYYY-MM-DD") != 0){
						docDet.put("refDate", docPayDate);
					}

					String docCCHolderName = String.valueOf(qryDocDet.get("ccHolderName")).trim().equals("null")
							|| String.valueOf(qryDocDet.get("ccHolderName")).trim().equals("") ? "" : String.valueOf(qryDocDet.get("ccHolderName")).trim();
					if(!(docRefNo.equals(payDet.getPayItemCCHolderName()))){
						docDet.put("ccHolderName", payDet.getPayItemCCHolderName());
					}

					String docCCExpiry = String.valueOf(qryDocDet.get("ccExpr")).trim().equals("null")
							|| String.valueOf(qryDet.get("ccExpr")).trim().equals("") ? "" : String.valueOf(qryDet.get("ccExpr")).trim();
					if(!(docCCExpiry.equals(payDet.getPayItemCCExpiryDate()))){
						//System.out.println("cCExpiryDate : " + cCExpiryDate + ", pay : " + payDet.getPayItemCCExpiryDate());
						docDet.put("ccExpiry", payDet.getPayItemCCExpiryDate());
					}

					String docTypeId = String.valueOf(qryDocDet.get("ccTypeId")).trim().equals("null")
							|| String.valueOf(qryDocDet.get("ccTypeId")).trim().equals("") ? "" : String.valueOf(qryDocDet.get("ccTypeId")).trim();
					if(!(docTypeId.equals(String.valueOf(payDet.getPayItemCCTypeId())))){
						docDet.put("ccTypeId", payDet.getPayItemCCTypeId());
					}

					docDet.put("updator", payDet.getUpdator() > 0 ? userId : 0);

					searchPaymentMapper.updatePayDocDetail(docDet);
				}
			}

		}
		return true;
	}

	private List<PayDHistoryVO> setHistoryList(PayDVO payDet, EgovMap qryDet){
		List<PayDHistoryVO> list = new ArrayList();

		//1130 : Ref Number
		String payItmRefNo = qryDet.get("payItmRefNo") == null ? "" : String.valueOf(qryDet.get("payItmRefNo"));
		if(!(String.valueOf(payItmRefNo).equals(payDet.getPayItemRefNo()))){
			PayDHistoryVO his = new PayDHistoryVO();

			his.setHistoryId(0);
			his.setTypeId(1130);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(payItmRefNo);
			his.setValueTo(payDet.getPayItemRefNo());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1131 : Ref Date
		String tmpRefDt = qryDet.get("payItmRefDt") == null ? "1900-01-01" : String.valueOf(qryDet.get("payItmRefDt"));
		String qryRefDt = tmpRefDt.split(" ")[0];
		String tmpPay = payDet.getPayItemRefDate().equals("") ? "01/01/1900" : payDet.getPayItemRefDate();
		String tmpPayDt[] = tmpPay.split("/");
		String payDt = tmpPayDt[2] + "-" + tmpPayDt[1] + "-" + tmpPayDt[0];
		if(CommonUtils.getDiffDate(payDt, qryRefDt, "YYYY-MM-DD") != 0){
			PayDHistoryVO his = new PayDHistoryVO();

			his.setHistoryId(0);
			his.setTypeId(1131);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			if(!CommonUtils.isEmpty(qryRefDt)){
				if(CommonUtils.getDiffDate(qryRefDt, "1900-01-01", "YYYY-MM-DD") > 0){
					his.setValueFr(qryRefDt);
				}else{
					his.setValueFr("");
				}
			}else{
				his.setValueFr("");
			}

			if(!CommonUtils.isEmpty(payDt)){
				if(CommonUtils.getDiffDate(payDt, "1900-01-01", "YYYY-MM-DD") > 0){
					his.setValueTo(payDt);
				}else{
					his.setValueTo("");
				}
			}else{
				his.setValueTo("");
			}
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1132 : Remark
		String payItmRem = qryDet.get("payItmRem") == null ? "" : String.valueOf(qryDet.get("payItmRem"));
		if(!(payItmRem.equals(payDet.getPayItemRemark()))){
			PayDHistoryVO his = new PayDHistoryVO();

			his.setHistoryId(0);
			his.setTypeId(1132);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(String.valueOf(payItmRem));
			his.setValueTo(payDet.getPayItemRemark());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1133
		if(qryDet.get("payItmModeId").equals(106) || qryDet.get("payItmModeId").equals(107) || qryDet.get("payItmModeId").equals(108)){
			String payItmIssuBankId = qryDet.get("payItmIssuBankId") == null ? "" : String.valueOf(qryDet.get("payItmIssuBankId"));
			if(!(payItmIssuBankId.equals(payDet.getPayItemIssuedBankId()))){
				PayDHistoryVO his = new PayDHistoryVO();

				String qryBankFr = selectBankCode(String.valueOf(qryDet.get("payItmIssuBankId")));
				String qryBankTo = selectBankCode(String.valueOf(payDet.getPayItemIssuedBankId()));

				his.setHistoryId(0);
				his.setTypeId(1133);
				his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
				his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
				if(qryBankFr != null && !qryBankFr.equals("")){
					his.setValueFr(qryBankFr);
				}else{
					his.setValueFr("");
				}
				if(qryBankTo != null && !qryBankTo.equals("")){
					his.setValueTo(qryBankTo);
				}else{
					his.setValueTo("");
				}

				if(qryDet.get("payItmIssuBankId").toString() != null){
					his.setRefIdFr(Integer.parseInt(qryDet.get("payItmIssuBankId").toString()));
				}else{
					his.setRefIdFr(0);
				}
				his.setRefIdTo(payDet.getPayItemIssuedBankId());
				his.setCreateAt(payDet.getUpdated());
				his.setCreateBy(payDet.getUpdator());
				list.add(his);
			}
		}

		if(Integer.parseInt(qryDet.get("payItmModeId").toString()) == 107){
			//1134 : CrcHolder
			String payItmCcHolderName = qryDet.get("payItmCcHolderName") == null ? "" : String.valueOf(qryDet.get("payItmCcHolderName"));
			if(!(payItmCcHolderName.equals(payDet.getPayItemCCHolderName()))){
			//if(Sting.valueOf(qryDet.get("payItmCcHolderName")) != payDet.getPayItemCCHolderName().toString()){
				PayDHistoryVO his = new PayDHistoryVO();

				his.setHistoryId(0);
				his.setTypeId(1134);
				his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
				his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
				his.setValueFr(payItmCcHolderName);
				his.setValueTo(payDet.getPayItemCCHolderName());
				his.setRefIdFr(0);
				his.setRefIdTo(0);
				his.setCreateAt(payDet.getUpdated());
				his.setCreateBy(payDet.getUpdator());
				list.add(his);
			}
		}

		//1135 : Crc Expiry
		String payItmCcExprDt = qryDet.get("payItmCcExprDt") == null ? "" : String.valueOf(qryDet.get("payItmCcExprDt"));
		if(!(payItmCcExprDt.equals(payDet.getPayItemCCExpiryDate()))){
			PayDHistoryVO his = new PayDHistoryVO();
			his.setHistoryId(0);
			his.setTypeId(1135);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(payItmCcExprDt);
			his.setValueTo(payDet.getPayItemCCExpiryDate());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1136 : Crc Type
		String payItmCcTypeId = qryDet.get("payItmCcTypeId") == null ? "" : String.valueOf(qryDet.get("payItmCcTypeId"));
		if(!(payItmCcTypeId.equals(String.valueOf(payDet.getPayItemCCTypeId())))){
			PayDHistoryVO his = new PayDHistoryVO();

			String qryTypeFr = selectCodeDetail(Integer.parseInt(String.valueOf(payItmCcTypeId).equals("") ? "-1": String.valueOf(payItmCcTypeId)));
			String qryTypeTo = selectCodeDetail(Integer.parseInt(String.valueOf(payDet.getPayItemCCTypeId()).equals("") ? "-1": String.valueOf(payDet.getPayItemCCTypeId())));

			his.setHistoryId(0);
			his.setTypeId(1136);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			if(qryTypeFr != null && !qryTypeFr.equals("")){
				his.setValueFr(qryTypeFr);
			}else{
				his.setValueFr("");
			}

			if(qryTypeTo != null && !qryTypeTo.equals("")){
				his.setValueTo(qryTypeTo);
			}else{
				his.setValueTo("");
			}

			if(payItmCcTypeId != null && !payItmCcTypeId.equals("")){
				his.setRefIdFr(Integer.parseInt(payItmCcTypeId));
			}else{
				his.setRefIdFr(0);
			}
			his.setRefIdTo(payDet.getPayItemCCTypeId());
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1196 : Running Number
		String payItmRunngNo = qryDet.get("payItmRunngNo") == null ?  "" : String.valueOf(qryDet.get("payItmRunngNo"));
		if(!(payItmRunngNo.equals(payDet.getPayItemRunningNo()))){
			PayDHistoryVO his = new PayDHistoryVO();
			his.setHistoryId(0);
			his.setTypeId(1196);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(payItmRunngNo);
			his.setValueTo(payDet.getPayItemRunningNo());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1197 : EFT Number
		String payItmEftNo = qryDet.get("payItmEftNo") == null ?  "" : String.valueOf(qryDet.get("payItmEftNo"));
		if(!(payItmEftNo.equals(payDet.getPayItemEFTNo()))){
			PayDHistoryVO his = new PayDHistoryVO();
			his.setHistoryId(0);
			his.setTypeId(1197);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(payItmEftNo);
			his.setValueTo(payDet.getPayItemEFTNo());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}

		//1242 : Card Type
		int currentCardTypeId = !(String.valueOf(qryDet.get("payItmCardTypeId")).equals("null")) ? Integer.parseInt(qryDet.get("payItmCardTypeId").toString()) : 0;
		if(currentCardTypeId != payDet.getPayItemCardTypeId()){
			PayDHistoryVO his = new PayDHistoryVO();

			String qryTypeFr = selectCodeDetail(Integer.parseInt(String.valueOf(currentCardTypeId).equals("") ? "-1" : String.valueOf(currentCardTypeId)));
			String qryTypeTo = selectCodeDetail(Integer.parseInt(String.valueOf(payDet.getPayItemCardTypeId()).equals("") ? "-1" :  String.valueOf(payDet.getPayItemCardTypeId())));

			his.setHistoryId(0);
			his.setTypeId(1242);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			if(qryTypeFr != null){
				his.setValueFr(qryTypeFr);
			}else{
				his.setValueFr("");
			}
			if(qryTypeTo != null){
				his.setValueTo(qryTypeTo);
			}else{
				his.setValueTo("");
			}
			if(!String.valueOf(qryDet.get("payItmCardTypeId")).equals("null"))
			{
				his.setRefIdFr(Integer.parseInt(qryDet.get("payItmCardTypeId").toString()));
			}
			his.setRefIdTo(payDet.getPayItemCardTypeId());

			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());

			list.add(his);
		}

		return list;
	}

	/**
	 * updGlReceiptBranchId 업데이트
	 * @param params
	 * @return
	 */
	@Override
	public void updGlReceiptBranchId(Map<String, Object> params) {
		searchPaymentMapper.updGlReceiptBranchId(params);
	}

	/**
	 * selectPayDs   조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPayDs(Map<String, Object> params) {
		return searchPaymentMapper.selectPayDs(params);
	}

	/**
	 * selectGlRoute   조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectGlRoute(String param) {
		return searchPaymentMapper.selectGlRoute(param);
	}

	/**
	 * selectPaymentItemIsPassRecon 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectPaymentItemIsPassRecon(Map<String, Object> params) {
		return searchPaymentMapper.selectPaymentItemIsPassRecon(params);
	}

	/**
	 * RentalCollectionByBSAgingMonth 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<RentalCollectionByBSSearchVO> searchRCByBSAgingMonthList(RentalCollectionByBSSearchVO searchVO) {
		return searchPaymentMapper.searchRCByBSAgingMonthList(searchVO);
	}

	/**
     * RentalCollectionByBSAgingMonth 조회
     * @param params
     * @return
     */
    @Override
    public List<EgovMap> searchRCByBSAgingMonthNewList(Map<String, Object> params) {
        return searchPaymentMapper.searchRCByBSAgingMonthNewList(params);
    }

	@Override
	public List<RentalCollectionByOrganizationVO> searchRCByOrganizationList(RentalCollectionByOrganizationVO searchVO) {
		return searchPaymentMapper.searchRCByOrganizationList(searchVO);
	}

}
