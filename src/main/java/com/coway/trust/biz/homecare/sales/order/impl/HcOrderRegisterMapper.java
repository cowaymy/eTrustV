package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRegisterMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcOrderRegisterMapper")
public interface HcOrderRegisterMapper {

	/**
	 * Select Homecare Product List
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 18.
	 * @param params
	 * @return list
	 */
	public List<EgovMap> selectHcProductCodeList(Map<String, Object> params);

	/**
	 * Homecare Order Insert - HMC0011D
	 *
	 * @Author KR-SH
	 * @Date 2019. 11. 6.
	 * @param vo
	 * @return
	 */
	public int insertHcRegisterOrder(HcOrderVO hcOrderVO);

	/**
	 * Homecare Pre Order update - HMC0011D
	 *
	 * @Author KR-SH
	 * @Date 2019. 11. 7.
	 * @param vo
	 * @return
	 */
	public int updateHcPreOrder(HcOrderVO hcOrderVO);

	/**
	 * Get Order Seq No
	 * @Author KR-SH
	 * @Date 2019. 12. 16.
	 * @return
	 */
	public int getOrdSeqNo();

	/**
	 * Get Bndl No
	 * @Author KR-SH
	 * @Date 2019. 12. 16.
	 * @param hcOrderVO
	 * @return
	 */
	public String getBndlNo(int orderSeqNo);

	/**
	 * Get Product Size
	 * @Author KR-SH
	 * @Date 2019. 12. 16.
	 * @param product
	 * @return
	 */
	public String getProductSize(String product);

	/**
	 * Select Promotion By Frame
	 * @Author KR-SH
	 * @Date 2019. 12. 24.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectPromotionByFrame(Map<String, Object> params);


	public int getCountHcPreOrder(int orderSeqNo);
	public int getCountExistBndlId(String bndlId);
	public int getPrevOrdSeq(String bndlId);
	public int getPrevOrdId(Map<String, Object> params);
	public String getProductCategory(String product);

	public int chkPromoCboCan(Map<String, Object> params);
	public int chkPromoCboMst(Map<String, Object> params);
	public int chkPromoCboSub(Map<String, Object> params);
	public int chkCanMapCnt(Map<String, Object> params);
  public int chkQtyHcAcCmbByGroup(Map<String, Object> params);
	public int chkCmbGrpMaxQty(Map<String, Object> params);
	public int chkQtyCmbOrd(Map<String, Object> params);

	public List<EgovMap> selectHcAcComboOrderJsonList(Map<String, Object> params);
	public List<EgovMap> selectHcAcComboOrderJsonList_2(Map<String, Object> params);
	public List<EgovMap> selectHcAcCmbOrderDtlList(Map<String, Object> params);

	List<EgovMap> selectPwpOrderNoList(Map<String, Object> params);
}
