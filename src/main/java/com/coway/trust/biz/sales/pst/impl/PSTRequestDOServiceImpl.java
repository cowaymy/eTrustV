/**
 * 
 */
package com.coway.trust.biz.sales.pst.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.pst.PSTLogVO;
import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.biz.sales.pst.PSTSalesDVO;
import com.coway.trust.biz.sales.pst.PSTSalesMVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("pstRequestDOService")
public class PSTRequestDOServiceImpl extends EgovAbstractServiceImpl implements PSTRequestDOService {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "pstRequestDOMapper")
	private PSTRequestDOMapper pstRequestDOMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectPstRequestDOList(Map<String, Object> params) {
		
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.selectPstRequestDOList(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public EgovMap getPstRequestDODetailPop(Map<String, Object> params) {
		
		logger.debug("getPstRequestDODetaiPop serviceImpl 호출 : " + params.get("pstSalesOrdId"));
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.getPstRequestDODetailPop(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	
	public List<EgovMap> getPstRequestDOStockDetailPop(Map<String, Object> params) {
		
		logger.debug("getPstRequestDODetaiPop serviceImpl 호출 : " + params.get("pstSalesOrdId"));
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.getPstRequestDOStockDetailPop(params);
	}
	
	/**
	 * 글을 수정한다.
	 * 
	 * @param vo
	 *            - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	@Override
	public void updateStock(List<PSTSalesDVO> pstSalesDVOList, PSTSalesMVO pstSalesMVO) {
		
		PSTLogVO pstLogVO = null;
		
		BigDecimal totalAmt = CalcItemsAmountTotal(pstSalesDVOList);
		
		logger.debug("##### totalAmt :"+totalAmt);
		
		int totalBal = 0;
		int statusID = 0;
		
		for(PSTSalesDVO pstSalesDVO : pstSalesDVOList) {
			
			int newPstItmCanQty = pstSalesDVO.getPstItmCanQty2(); //Quantity to cancel		
			int newPstItmBalQty = pstSalesDVO.getPstItmBalQty() - newPstItmCanQty; //(Balance Quantity) - (Quantity to cancel)
			
			totalBal += newPstItmBalQty;
			
			pstSalesDVO.setPstItmBalQty(newPstItmBalQty);
			pstSalesDVO.setPstItmCanQty(pstSalesDVO.getPstItmCanQty() + newPstItmCanQty);
			pstSalesDVO.setPstItmTotPrc(BigDecimal.valueOf(newPstItmBalQty).multiply(pstSalesDVO.getPstItmPrc()));
			
			pstRequestDOMapper.updatePstSalesD(pstSalesDVO);

			if(newPstItmCanQty > 0) {
    			pstLogVO = new PSTLogVO();
    			
    			pstLogVO.setPstSalesOrdId(pstSalesDVO.getPstSalesOrdId());
    			pstLogVO.setPstStockId(pstSalesDVO.getPstItmStkId());
    			pstLogVO.setPstStockRem(pstSalesDVO.getPstStockRem());
    			pstLogVO.setPstQty(newPstItmCanQty); //입력받은 취소수량
    			pstLogVO.setPstTypeId(SalesConstants.SALES_PSTCAN_CODEID);
    			pstLogVO.setPstRefNo(pstSalesMVO.getPstRefNo());
    			pstLogVO.setCrtUserId(9999);
    			
    			pstRequestDOMapper.insertPstLog(pstLogVO);
			}
		}
		
		statusID = totalBal == 0 ? 4 : 1;

		pstSalesMVO.setPstStusId(statusID);
		pstSalesMVO.setPstTotAmt(totalAmt);
		
		pstRequestDOMapper.updatePstSalesM(pstSalesMVO);
	}
	
    private BigDecimal CalcItemsAmountTotal(List<PSTSalesDVO> pstSalesDVOList)
    {
    	BigDecimal totalAmt = BigDecimal.ZERO;

        if(pstSalesDVOList.size() > 0) {
            
        	int canQty = 0;
            
        	for(PSTSalesDVO pstSalesDVO : pstSalesDVOList) {

        		canQty = pstSalesDVO.getPstItmCanQty2();

                //totalAmt += ((int.Parse(det.GetDataKeyValue("PSTItemBalQty").ToString()) - int.Parse(CanQty.ToString())) * double.Parse(ItemPrice.Value.ToString()));
                totalAmt = totalAmt.add(BigDecimal.valueOf(pstSalesDVO.getPstItmBalQty() - canQty).multiply(pstSalesDVO.getPstItmPrc()));
            }

        }

        return totalAmt;
    }
    
}
