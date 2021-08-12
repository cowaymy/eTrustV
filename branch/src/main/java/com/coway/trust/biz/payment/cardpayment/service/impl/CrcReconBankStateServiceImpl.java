package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;
import com.coway.trust.biz.payment.cardpayment.service.CrcReconBankStateService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("crcReconBankStateService")
public class CrcReconBankStateServiceImpl extends EgovAbstractServiceImpl implements CrcReconBankStateService {

	@Resource(name = "crcReconBankStateMapper")
	private CrcReconBankStateMapper crcReconBankStateMapper;


	/**
	 * Credit Card Statement Master List  조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectMappingList(Map<String, Object> params) {
		return crcReconBankStateMapper.selectMappingList(params);
	}

	/**
	 * Credit Card Statement Master List  조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectUnMappedCrc(Map<String, Object> params) {
		return crcReconBankStateMapper.selectUnMappedCrc(params);
	}

	@Override
	public List<EgovMap> selectUnMappedBank(Map<String, Object> params) {
		return crcReconBankStateMapper.selectUnMappedBank(params);
	}

	/**
	 * Bank & Crc 매핑 정보 업데이트 및 저장
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public int updateMappingData(List<Object> gridList, int userId) {

		for(int i=0; i<gridList.size(); i++){
			Map<String, Object> row = (HashMap<String, Object>) gridList.get(i);
			row.put("userId", userId);

			//crc 업데이트
			System.out.println(row);
			crcReconBankStateMapper.updateCrc(row);
			//bank 업데이트
			crcReconBankStateMapper.updateBank(row);

			//인터페이스에 추가
			double sum = 0;
			List<EgovMap> crcList = crcReconBankStateMapper.selectCrcIdList(row);
			List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
			for(int j=0; j<crcList.size(); j++){
				//그리드 다시 보여줘야 함...
				Map<String, Object> crcRow = new HashMap<String, Object>();
				crcRow.put("mappingDate", row.get("mappingDate"));
				crcRow.put("bankSeq", j+1);
				crcRow.put("codeId", row.get("codeId"));
				crcRow.put("trnscDate", row.get("fTrnscDt"));
				crcRow.put("mid", row.get("crcTrnscMid"));
				crcRow.put("appvNo", crcList.get(j).get("crcTrnscAppv"));
				crcRow.put("crcId", crcList.get(j).get("crcTrnscId"));
				crcRow.put("bankId", row.get("fTrnscId"));
				crcRow.put("grosAmt", crcList.get(j).get("crcGrosAmt"));
				crcRow.put("creditAmt", row.get("creditAmt"));
				insertList.add(crcRow);
				sum = sum+ Double.parseDouble(String.valueOf(crcList.get(j).get("crcGrosAmt")));
			}

			for(int j=0; j<insertList.size(); j++){
				insertList.get(j).put("diffAmt", sum - Double.parseDouble(String.valueOf(insertList.get(j).get("creditAmt"))));
				crcReconBankStateMapper.insertInterfaceTb(insertList.get(j));
			}



			// IF942  insert   Confirm Bank Charge I/F  add by hgham 2018-02-06
			if(((String) row.get("isAmtSame" )).equals("false")){
				Map<String, Object> ifM = new HashMap<String, Object>();

				ifM.put("userId", userId);
				ifM.put("accId",  row.get("accountCode" ));
				ifM.put("variance", row.get("variance" ));
				ifM.put("fTrnscId", row.get("fTrnscId" ));

				crcReconBankStateMapper.insertCardPaymentMatchIF(ifM);

			}
		}
		return 1;
	}

}
