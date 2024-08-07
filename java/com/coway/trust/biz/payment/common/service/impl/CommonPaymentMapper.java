package com.coway.trust.biz.payment.common.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("commonPaymentMapper")
public interface CommonPaymentMapper {

	/**
	 * Payment - Order Info 조회 : order No로 Order ID 조회하기
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrdIdByNo(Map<String, Object> params);

	/****************************************************************************
	 * Payment : Rental Order Info
	 ****************************************************************************/
	/**
	 * Payment - Order Info Rental 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetRentalOrders(int orderId, bool getBillingGroup)
	 */
	List<EgovMap> selectOrderInfoRental(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental Mega Deal여부  조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectMegaDealByOrderId(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : CN 값 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetRentalOrders(int orderId, bool getBillingGroup)
	 */
	EgovMap selectRPFCN(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : DN 값 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetRentalOrders(int orderId, bool getBillingGroup)
	 */
	EgovMap selectRPFDN(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : CN 값 조회 (Adjust Entry Amount)
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectRpfCnAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : NEW CN 값 조회 (Adjust Entry Amount)
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectRpfCnNewAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Pay Total Amount 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectPayTotalAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : RPF Total Amount 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectRpfTotBillAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Reversed Amount 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectReversedAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Reversed Payment Amount 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectRevPaymentAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Bill List 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	List<EgovMap> selectBills(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Order Info 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectOrderInfoForBills(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : RPF Paid 값 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectRpfPaidAmount(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Last Payment Date  값 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectLastPaymentDt(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Current Installment  값 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectRentInstNo(Map<String, Object> params);

	/**
	 * Payment - Order Info Rental 조회  : Last Billed Installment  값 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int orderId)
	 */
	EgovMap selectLastBilledInstNo(Map<String, Object> params);

	/****************************************************************************
	 * Payment : Rental Bill Info
	 ****************************************************************************/
	/**
	 * Payment - Bill Info Rental 조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	List<EgovMap> selectBillInfoRental(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : RPF Paid 값 조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRpfPaid(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : RPF Rev  값 조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRpfRev(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Adjustment CN / DN 값 조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillAdjAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Rental Paid Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRentalPaidAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Rental Rev Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRentalRevAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Penalty Paid Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillPenaltyPaidAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Penalty Rev Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillPenaltyRevAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Handling fees Paid Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRhfPaidAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Handling fees Rev Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRfhRevAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Handling fees Adjustment CN Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRhfCNAmount(Map<String, Object> params);

	/**
	 * Payment - Bill Info Rental 조회  : Handling fees Old Adjustment CN Amount  조회
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
	EgovMap selectBillRhfCNOldAmount(Map<String, Object> params);

	/****************************************************************************
	 * Payment : Non - Rental Order Info
	 ****************************************************************************/
	/**
	 * Payment - Order Info Non - Rental 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetOutInstOrders(int orderId)
	 */
	List<EgovMap> selectOrderInfoNonRental(Map<String, Object> params);

	List<EgovMap> selectHTOrderInfoNonRental(Map<String, Object> params);

	/**
	 * Payment - Bill Info Non - Rental : Ledger 카운트 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetOutInstOrders(int orderId)
	 */
	EgovMap selectBillInfoLedgerCnt(Map<String, Object> params);

	/**
	 * Payment - Bill Info Non - Rental : Ledger Info 조회
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetOutInstOrders(int orderId)
	 */
	EgovMap selectLedgerInfo(Map<String, Object> params);

	/****************************************************************************
	 * Payment : Membership Service  : FundTransfer
	 ****************************************************************************/
	/**
	 * Payment - Order Info Membership Service 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	Map<String, Object> selectOrderInfoSVM(Map<String, Object> params);


	/*****************************************************************************
	 *  Rental Membership : Payment
	 *
	 ******************************************************************************/
	/**
	 * Payment - Order Info Rental Membership 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	List<EgovMap> selectOrderInfoSrvc(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Filter, Penalty Charge
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcCharge(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Filter, Penalty Adjustment CN / DN 값 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcADJ(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Filter, Penalty Paid Amount 값 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcPaid(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Filter, Penalty Reversed Amount 값 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcRev(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Total Reversed Amount 값 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcTotalRev(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Balance Amount 값 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcBalance(Map<String, Object> params);

	/**
	 *  Payment - Order Info Rental Membership 조회 : Unbill Info 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOrderInfoSrvcUnbill(Map<String, Object> params);

	/**
	 *  Payment - Bill Info Rental Membership 조회 : Filter Paid  조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectBillInfoSrvcPaid(Map<String, Object> params);

	/**
	 *  Payment - Bill Info Rental Membership 조회 : Filter Reversed Info 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectBillInfoSrvcRev(Map<String, Object> params);

	/**
	 *  Payment - Bill Info Rental Membership 조회 : Filter Reversed Info 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	List<EgovMap> selectBillInfoSrvcList(Map<String, Object> params);


	/**
	 * Payment - Order Info Rental Payment AS 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	List<EgovMap> selectOrderInfoBillPaymentAS (Map<String, Object> params);

	/**
	 * Payment - Order Info Rental Payment HP 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	List<EgovMap> selectOrderInfoBillPaymentHP (Map<String, Object> params);

	/**
	 * Payment - Order Info Rental Payment POS 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	List<EgovMap> selectOrderInfoBillPaymentPOS (Map<String, Object> params); // Add Bill Type - POS - TPY 21/06/2018

	/****************************************************************************
	 * Payment : Outright Membership
	 ****************************************************************************/
	/**
	 * Payment - Outright Membership Order 정보 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */

	List<EgovMap> selectOutSrvcOrderInfo(Map<String, Object> params);

	/**
	 * Payment - Outright Membership Bill 정보 조회
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	EgovMap selectOutSrvcBillInfo(Map<String, Object> params);

	EgovMap selectCareServicePayInfo(Map<String, Object> params);

	/**
	 * Payment 임시정보 Sequence 가져오기
	 * @return
	 */
	Integer getPayTempSEQ();

	/**
	 * Payment 임시정보 등록하기
	 * @return
	 */
	void insertTmpPaymentInfo(Map<String, Object> params);


	int countTmpPaymentInfoFT(Map<String, Object> params);

	/**
	 * Payment 임시정보 등록하기 : Fund Transfer용
	 * @return
	 */
	void insertTmpPaymentInfoFT(Map<String, Object> params);

	/**
	 * Payment 임시정보 등록하기 : Fund Transfer용
	 * @return
	 */
	void insertTmpPaymentInfoFT2(Map<String, Object> params);

	/**
	 * Payment Billing 임시정보 등록하기
	 * @return
	 */
	void insertTmpBillingInfo(Map<String, Object> params);


	/**
	 * Payment 처리 프로시저 처리
	 * @param params
	 * @return
	 */
	int processPayment(Map<String, Object> params);


	/**
	 * Normal Payment TMP테이블에 저장
	 * @param params
	 * @return
	 */
	int insertTmpNormalPaymentInfo(Map<String, Object>params);

	/**
	 * NormalPayment 처리 프로시저 처리
	 * @param params
	 * @return
	 */
	void processNormalPayment(Map<String, Object> params);

	/**
	 * Payment - Key In 처리후 WOR 번호 조회하기
	 * @param params
	 * @param model
	 * @return
	 *
	 */
	List<EgovMap> selectProcessPaymentResult(Map<String, Object> params);

	List<EgovMap> selectProcessCSPaymentResult(Map<String, Object> params);

	void updateCareSalesMStatus(Object object);

	String selectOrderRentalAccntStatus(Map<String, Object> params);

	EgovMap checkBatchPaymentExist(Map<String, Object> params);

}
