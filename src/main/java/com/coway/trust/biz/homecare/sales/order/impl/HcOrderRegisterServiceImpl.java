package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderRegisterServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderRegisterService")
public class HcOrderRegisterServiceImpl extends EgovAbstractServiceImpl implements HcOrderRegisterService {

  	@Resource(name = "hcOrderRegisterMapper")
  	private HcOrderRegisterMapper hcOrderRegisterMapper;

  	@Resource(name = "orderRegisterService")
  	private OrderRegisterService orderRegisterService;

  	/**
  	 * Select Homacare Product List
  	 *
  	 * @Author KR-SH
  	 * @Date 2019. 10. 18.
  	 * @param params
  	 * @return list
  	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService#selectHcProductCodeList(java.util.Map)
  	 */
    @Override
    public List<EgovMap> selectHcProductCodeList(Map<String, Object> params) {
    	return hcOrderRegisterMapper.selectHcProductCodeList(params);
    }

    /**
     * Homecare Register Order
     *
     * @Author KR-SH
     * @Date 2019. 10. 23.
     * @param orderVO
     * @param sessionVO
     * @throws ParseException
     * @see com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService#hcRegisterOrder(com.coway.trust.biz.sales.order.vo.OrderVO, com.coway.trust.cmmn.model.SessionVO)
     */
	@Override
	public void hcRegisterOrder(OrderVO orderVO, SessionVO sessionVO) throws ParseException {
		String matOrdNo = "";     // Mattress Order No
		String fraOrdNo = "";       // Frame Order No.
		int matOrdId = 0;
		int rtnCnt = 0;
		SalesOrderMVO salesOrderMVO1 = orderVO.getSalesOrderMVO1();
		SalesOrderMVO salesOrderMVO2 = null;
		String hcSetOrdYn = "N";

		int custId = CommonUtils.intNvl(salesOrderMVO1.getCustId());     // Cust Id
		int matStkId = CommonUtils.intNvl(orderVO.getSalesOrderDVO1().getItmStkId());
		int fraStkId = CommonUtils.intNvl(orderVO.getSalesOrderDVO2().getItmStkId());
		String ordChgYn = CommonUtils.nvl(orderVO.getCopyOrderChgYn());

		if(custId <= 0) {
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Null Customer ID");
		}
		// 제품이 둘다 없는 경우.
		if(matStkId+fraStkId <= 0) {
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Null Product ID");
		}

		// has order frame
		if(matStkId > 0 && fraStkId > 0) {
			hcSetOrdYn = "Y";
			salesOrderMVO2 = orderVO.getSalesOrderMVO2();
			salesOrderMVO2.setAppTypeId(SalesConstants.APP_TYPE_CODE_ID_AUX);
			BigDecimal discRntFee2 = salesOrderMVO2.getDiscRntFee();  // frame rental fee

			// mattress order (mth_rent_amt, def_rent_amt) + frame order(disc_rnt_fee)
			salesOrderMVO1.setMthRentAmt(salesOrderMVO1.getMthRentAmt().add(discRntFee2));
			salesOrderMVO1.setDefRentAmt(salesOrderMVO1.getDefRentAmt().add(discRntFee2));

			// frame order (mth_rent_amt, def_rent_amt) = 0
			salesOrderMVO2.setMthRentAmt(BigDecimal.ZERO);
			salesOrderMVO2.setDefRentAmt(BigDecimal.ZERO);
			salesOrderMVO2.setTotAmt(BigDecimal.ZERO);
			salesOrderMVO2.setTotPv(BigDecimal.ZERO);

			BigDecimal norAmt1 = salesOrderMVO1.getNorAmt(); // mattress NOR_AMT
			norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

			BigDecimal norAmt2 = salesOrderMVO2.getNorAmt(); // frame NOR_AMT
			norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;

			// mattress order NOR_AMT + frame order NOR_AMT
			salesOrderMVO1.setNorAmt(norAmt1.add(norAmt2));
			// frame order NOR_AMT = 0
			salesOrderMVO2.setNorAmt(BigDecimal.ZERO);
		}else if(matStkId <= 0 && fraStkId > 0){
		  salesOrderMVO2 = orderVO.getSalesOrderMVO2();
		}

		// Order Copy(Change) -> ordSeqNo = 0
		int ordSeqNo = ("Y".equals(ordChgYn) && matStkId > 0) ? 0 : CommonUtils.intNvl(orderVO.getOrdSeqNo());
		if(ordSeqNo <= 0) {
			ordSeqNo = hcOrderRegisterMapper.getOrdSeqNo();
		}

		// set OrderVO
		orderVO.setBndlId(ordSeqNo);
		orderVO.setHcSetOrdYn(hcSetOrdYn);

		// Mattress register
		if(matStkId > 0) {
			// Mattress register - set OrderVO
			orderVO.setSalesOrderMVO(salesOrderMVO1);
			orderVO.setSalesOrderDVO(orderVO.getSalesOrderDVO1());
			orderVO.setAccClaimAdtVO(orderVO.getAccClaimAdtVO1());
			orderVO.setPreOrdId(orderVO.getMatPreOrdId());
			orderVO.setMatAppTyId(orderVO.getSalesOrderMVO().getAppTypeId());

			orderRegisterService.registerOrder(orderVO, sessionVO);
			matOrdNo = orderVO.getSalesOrderMVO().getSalesOrdNo();
			matOrdId =  CommonUtils.intNvl(orderVO.getSalesOrderMVO().getSalesOrdId());
			if("".equals(matOrdNo)) { // not insert - Mattress order
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Mattress");
			}
		}

		// Frame register
		if(fraStkId > 0) {
			// Frame register - set OrderVO
			orderVO.setSalesOrderMVO(salesOrderMVO2);
			orderVO.setSalesOrderDVO(orderVO.getSalesOrderDVO2());
			orderVO.setAccClaimAdtVO(orderVO.getAccClaimAdtVO2());
			orderVO.setPreOrdId(orderVO.getFraPreOrdId());

			orderRegisterService.registerOrder(orderVO, sessionVO);
			fraOrdNo = orderVO.getSalesOrderMVO().getSalesOrdNo();
			if("".equals(fraOrdNo)) { // not insert - frame order
				throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Frame");
			}
		}

		// 홈케어 주문관리 테이블 insert - HMC0011D
		HcOrderVO hcOrderVO = new HcOrderVO();

		//String ecommBndlId = null;
		String ecommBndlId = orderVO.getSalesOrderMVO().geteCommBndlId() != null ? orderVO.getSalesOrderMVO().geteCommBndlId().toString() : null;
		/*if(orderVO.getSalesOrderMVO().geteCommBndlId() != null)
		{
			ecommBndlId = orderVO.getSalesOrderMVO().geteCommBndlId().toString();
		}*/
		int cntHcOrder = hcOrderRegisterMapper.getCountHcPreOrder(ordSeqNo);
		int cntHcExisted = hcOrderRegisterMapper.getCountExistBndlId(ecommBndlId);
		String bndlNo = hcOrderRegisterMapper.getBndlNo(ordSeqNo);

		hcOrderVO.setCustId(custId);                     // 고객번호
		hcOrderVO.setMatOrdNo(matOrdNo);        // Mattress Order No
		hcOrderVO.setFraOrdNo(fraOrdNo);           // Frame Order No
		hcOrderVO.setCrtUserId(sessionVO.getUserId());    // session Id Setting
		hcOrderVO.setUpdUserId(sessionVO.getUserId());  // session Id Setting
		hcOrderVO.setOrdSeqNo(ordSeqNo);
		hcOrderVO.setBndlNo(bndlNo);
		hcOrderVO.setSrvOrdId(matOrdId);
		if(cntHcExisted > 0)
		{
			hcOrderVO.setOrdSeqNo(ordSeqNo);
		}

		// Pre Order 인 경우.
		if(cntHcOrder > 0) {
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
		}else if(cntHcExisted > 1)
		{
			int eCommOrdSeq = hcOrderRegisterMapper.getPrevOrdSeq(ecommBndlId);
			hcOrderVO.setOrdSeqNo(eCommOrdSeq);
			rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcOrderVO);
		}
		else {
			rtnCnt = hcOrderRegisterMapper.insertHcRegisterOrder(hcOrderVO);
		}

		if(rtnCnt <= 0) { // not insert
			throw new ApplicationException(AppConstants.FAIL, "Order Register Failed.");
		}
		orderVO.setHcOrderVO(hcOrderVO);
	}

	@Override
	public boolean checkProductSize(Map<String, Object> params) {
		String productSize1 = hcOrderRegisterMapper.getProductSize(CommonUtils.nvl(params.get("product1")));
		String productSize2 = hcOrderRegisterMapper.getProductSize(CommonUtils.nvl(params.get("product2")));

		if(CommonUtils.nvl(productSize1).equals(CommonUtils.nvl(productSize2))) {
			return true;
		}

		return false;
	}

	/**
	 * Select Promotion By Frame
	 * @Author KR-SH
	 * @Date 2019. 12. 24.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService#selectPromotionByFrame(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectPromotionByFrame(Map<String, Object> params) {
		return hcOrderRegisterMapper.selectPromotionByFrame(params);
	}

}
