/**
 *
 */
package com.coway.trust.biz.payment.report.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialChange.impl.SerialChangeServiceImpl;
import com.coway.trust.biz.payment.report.CCDReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CCDReportServiceImpl.java
 * @Description : CCDReportServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 30.   KR-HAN        First creation
 * </pre>
 */
@Service("ccdReportService")
public class CCDReportServiceImpl extends EgovAbstractServiceImpl implements CCDReportService {

  private static Logger logger = LoggerFactory.getLogger(SerialChangeServiceImpl.class);

  @Resource(name = "ccdReportMapper")
  private CCDReportMapper ccdReportMapper;

    /**
     * selectCustomerTypeNPayChannelReporJsonList
     * @Author KR-HAN
     * @Date 2019. 12. 30.
     * @param params
     * @return
     * @see com.coway.trust.biz.logistics.report.CCDReportService#selectCustomerTypeNPayChannelReporJsonList(java.util.Map)
     */
    @Override
	public Map<String, Object> selectCustomerTypeNPayChannelReportJsonList(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();

		logger.info("++++ selectCustomerTypeNPayChannelReporJsonList params :: {}", params );

		Integer lastDay = ccdReportMapper.selectLastDay(params);
    	List<EgovMap> grid1List = ccdReportMapper.selectCustomerTypeNPayChannelReportJsonList1(params);
    	List<EgovMap> grid2List = ccdReportMapper.selectCustomerTypeNPayChannelReportJsonList2(params);
    	List<EgovMap> grid3List = ccdReportMapper.selectCustomerTypeNPayChannelReportJsonList3(params);
    	List<EgovMap> grid4List = ccdReportMapper.selectCustomerTypeNPayChannelReportJsonList4(params);

    	map.put("lastDay", lastDay);
    	map.put("grid1List", grid1List);
    	map.put("grid2List", grid2List);
    	map.put("grid3List", grid3List);
    	map.put("grid4List", grid4List);

		return map;
	}

	/**
	 * selectIssuerBankReportJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.logistics.report.CCDReportService#selectIssuerBankReportJsonList(java.util.Map)
	 */
	@Override
	public Map<String, Object>  selectIssuerBankReportJsonList(Map<String, Object> params) {
		// TODO Auto-generated method stub

		Map<String, Object> map = new HashMap<String, Object>();


		Integer lastDay = ccdReportMapper.selectLastDay(params);
    	List<EgovMap> gridList = ccdReportMapper.selectIssuerBankReportJsonList(params);

    	map.put("lastDay", lastDay);
    	map.put("gridList", gridList);

		return map;
	}

    /**
     * selectActualPaymentTypeSummaryReportJsonList
     * @Author KR-HAN
     * @Date 2019. 12. 30.
     * @param params
     * @return
     * @see com.coway.trust.biz.logistics.report.CCDReportService#selectActualPaymentTypeSummaryReportJsonList(java.util.Map)
     */
    @Override
	public Map<String, Object> selectActualPaymentTypeSummaryReportJsonList(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();

		logger.info("++++ selectActualPaymentTypeSummaryReportJsonList params :: {}", params );

    	List<EgovMap> orderCountList = ccdReportMapper.selectActualPaymentTypeSummaryOrderCountReportJsonList(params);
    	List<EgovMap> amoutList = ccdReportMapper.selectActualPaymentTypeSummaryAmoutReportJsonList(params);

    	map.put("orderCountList", orderCountList);
    	map.put("amoutList", amoutList);

		return map;
	}
}
