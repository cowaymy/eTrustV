package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentMatchService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("advPaymentMatchService")
public class AdvPaymentMatchServiceImpl extends EgovAbstractServiceImpl implements AdvPaymentMatchService {

	@Resource(name = "advPaymentMatchMapper")
	private AdvPaymentMatchMapper advPaymentMatchMapper;

	@Resource(name = "paymentListMapper")
	private PaymentListMapper paymentListMapper;

	private static final Logger LOGGER = LoggerFactory.getLogger(AdvPaymentMatchServiceImpl.class);

	@Override
	public List<EgovMap> selectAdvKeyInList(Map<String, Object> params) {
		return advPaymentMatchMapper.selectAdvKeyInList(params);
	}

	@Override
	public List<EgovMap> selectBankStateMatchList(Map<String, Object> params) {
		return advPaymentMatchMapper.selectBankStateMatchList(params);
	}

	/**
	 * Advance Payment Matching - Mapping 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	@Transactional
	public void saveAdvPaymentMapping(Map<String, Object> params) {

		//Group Payment Mapping처리
		advPaymentMatchMapper.mappingAdvGroupPayment(params);

		//Bank Statement Mapping 처리
		advPaymentMatchMapper.mappingBankStatementAdv(params);

		//Interface 테이블 처리 - Bank Statement Bank Charge
		List<EgovMap> returnList = advPaymentMatchMapper.selectMappedData(params);


		if(returnList != null && returnList.size() > 0){
			for(int i = 0 ; i < returnList.size(); i++){

				EgovMap ifMap  = (EgovMap) returnList.get(i);


				//variance
				ifMap.put("variance", params.get("variance"));
				ifMap.put("userId", params.get("userId"));
				advPaymentMatchMapper.insertAdvPaymentMatchIF(ifMap);
				advPaymentMatchMapper.updateDiffTypeDiffAmt(ifMap);
			}
		}
	}

	 /**
	 * Advance Payment Matching - Reverse 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public EgovMap requestDCFWithAppv(Map<String, Object> params) {

		EgovMap returnMap = new EgovMap();

		int count = paymentListMapper.invalidDCF(params);

		if (count > 0) {
			returnMap.put("error", "DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR')");
		} else {
			//DCF Request 등록
			paymentListMapper.requestDCF(params);

			//Group Payment 정보 수정
			params.put("revStusId", "1");
			paymentListMapper.updateGroupPaymentRevStatus(params);


			//Approval DCF 처리 프로시저 호출
			params.put("reqNo", params.get("dcfReqId"));
			paymentListMapper.approvalDCF(params);

			returnMap.put("returnKey", params.get("dcfReqId"));
		}

		return returnMap;

	}

	 /**
	 * Advance Payment Matching - Debtor 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	@Transactional
	public void saveAdvPaymentDebtor(Map<String, Object> params) {

		//Group Payment Mapping처리
		params.put("remark", params.get("debtorRemark"));
		advPaymentMatchMapper.mappingAdvGroupPayment(params);

		//Interface 테이블 처리 - Bank Statement Bank Charge
		List<EgovMap> returnList = advPaymentMatchMapper.selectMappedData(params);

		if(returnList != null && returnList.size() > 0){
			for(int i = 0 ; i < returnList.size(); i++){

				EgovMap ifMap  = (EgovMap) returnList.get(i);

				//variance
				ifMap.put("variance", params.get("variance"));
				ifMap.put("userId", params.get("userId"));
				advPaymentMatchMapper.insertAdvPaymentDebtorIF(ifMap);
			}
		}
	}

	 @Override
	  public List<EgovMap> selectJompayMatchList(Map<String, Object> params) {
	    return advPaymentMatchMapper.selectJompayMatchList(params);
	  }

  @Override
  public EgovMap saveJompayPaymentMapping(Map<String, Object> params) {
    return advPaymentMatchMapper.saveJompayPaymentMapping(params);
  }

  @Override
  public List<EgovMap> selectAdvanceMatchList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return advPaymentMatchMapper.selectAdvanceMatchList(params);
  }

  @Override
  public EgovMap saveAdvancePaymentMapping(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return advPaymentMatchMapper.saveAdvancePaymentMapping(params);
  }
}
