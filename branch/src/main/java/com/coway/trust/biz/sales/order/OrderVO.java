/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.io.Serializable;
import java.util.List;

/**
 * @author Yunseok_Jang
 *
 */
public class OrderVO implements Serializable {

	private static final long serialVersionUID = -1258637558522223071L;

	private List<OrderReferralVO> orderReferralVO;

	public List<OrderReferralVO> getOrderReferralVO() {
		return orderReferralVO;
	}

	public void setOrderReferralVO(List<OrderReferralVO> orderReferralVO) {
		this.orderReferralVO = orderReferralVO;
	}
	
}
