package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.customer.impl.CustomerScoreCardMapper;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerScoreCardService")
public class CustomerScoreCardServiceImpl extends EgovAbstractServiceImpl implements CustomerScoreCardService {

  @Resource(name = "customerScoreCardMapper")
  private CustomerScoreCardMapper customerScoreCardMapper;

  /**
   * 글 목록을 조회한다.
   *
   * @param OrderCancelVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  public List<EgovMap> customerScoreCardList(Map<String, Object> params) {

	  List <EgovMap> customerScoreList = customerScoreCardMapper.customerScoreCardList(params);

	 for(EgovMap custOrder : customerScoreList){
		  EgovMap latestBillNoMap = customerScoreCardMapper.getLatestBillNo(custOrder);
		  int latestBill=0;
		  int currentInstallment=0;
		  int unbillCount=0;
		  double unbillAmount= 0.0D;
		  double rentalAmt =0.0D;

		  if (latestBillNoMap != null && latestBillNoMap.get("lastRentInstNo") != null) {
			  latestBill = Integer.parseInt(String.valueOf(latestBillNoMap.get("lastRentInstNo")));
		  }

		  currentInstallment = Integer.parseInt(String.valueOf(custOrder.get("rentInstNo")));
		  rentalAmt = Double.parseDouble(String.valueOf(custOrder.get("mthRentAmt")));
		  if (currentInstallment > 0) {
		      unbillCount = currentInstallment - latestBill;
		      if (unbillCount > 0)
		        unbillAmount = unbillCount * rentalAmt;
		  }

		  custOrder.put("memType", params.get("memType"));
		  custOrder.put("unbillAmt",unbillAmount);

	  }

	 return customerScoreList;
  }

  public String getMemType(Map<String, Object> params) {
	  return customerScoreCardMapper.getMemType(params);
  }
}
