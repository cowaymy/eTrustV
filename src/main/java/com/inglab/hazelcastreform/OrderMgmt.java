package com.inglab.hazelcastreform;

import com.coway.trust.biz.sales.order.impl.OrderListServiceImpl;
import com.inglab.hazelcast.exec.CriteriaType;
import com.inglab.hazelcast.exec.MapStoreQueryHelper;
import com.inglab.hazelcast.exec.QueryCriteria;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/*
package com.coway.trust.biz.sales.order.impl;
OrderListServiceImpl

line: 55

create index idx_ordermgmtt_salesdt on OrderMgmtT(SALES_DT);
create index idx_ordermgmtt_app_type_id on OrderMgmtT(APP_TYPE_ID);
create index idx_ordermgmtsecondchoose_sales_ord_id on OrderMgmtSecondChoose(SALES_ORD_ID);
create index idx_ordermgmtt_ord_id on OrderMgmtT(ORD_ID);
create index idx_ordermgmtt_ord_no on OrderMgmtT(ORD_NO) TYPE SORTED;
 */


public class OrderMgmt extends MapStoreQueryHelper {

  private static Logger logger = LoggerFactory.getLogger(OrderMgmt.class);

    public static List<EgovMap> selectOrderList(Map<String, Object> params) {
      debugPassInParams(params);

      OrderMgmt orderMgmt = new OrderMgmt(new String[] {"10.201.32.149:5701","10.201.32.187:5701","10.201.32.205:5701"});

      String sql = orderMgmt.buildSql(params);

      logger.debug("Generated sql: " + sql);

      List<Map<String,Object>> resultSet = orderMgmt.genericMassageResultSet(orderMgmt.query(sql), Arrays.asList(new String[] {"CUST_IC"}), Arrays.asList(new String[] {"ORD_DT"}));
        resultSet = orderMgmt.sortResultSet(resultSet, Arrays.asList(new String[] {"ORD_NO"}), Arrays.asList(new Boolean[] {true}));

        return transformToEgovMapList(resultSet);
    }



    public String buildSql(Map<String,Object> params)
    {
        QueryCriteria memType = new QueryCriteria("memType", CriteriaType.STRING,params.get("memType")); //piMemType;
        QueryCriteria ordId = new QueryCriteria("ordId", CriteriaType.STRING,params.get("ordId")); //escSingleQuote(piOrdId, true);
        QueryCriteria ordNo = new QueryCriteria("ordNo", CriteriaType.STRING,params.get("ordNo")); //escSingleQuote(piOrdNo, true);
        QueryCriteria ordDt = new QueryCriteria("ordDt", CriteriaType.DATETIME,params.get("ordDt")); //changeDtStrAlwaysToYyyyMmDd(piOrdDt, false, true);
        //String ordDtEnd = changeDtStrAlwaysToYyyyMmDd(piOrdDt, true, true);
        List ordStartEndDts = new ArrayList<>();
        ordStartEndDts.add(params.get("ordStartDt"));
        ordStartEndDts.add(params.get("ordEndDt"));
        QueryCriteria ordStartDt = new QueryCriteria("ordStartEndDts", CriteriaType.DATETIME,ordStartEndDts); //changeDtStrAlwaysToYyyyMmDd(piOrdStartDt, false, true);
        //String ordEndDt = changeDtStrAlwaysToYyyyMmDd(piOrdEndDt, true, true);
        QueryCriteria memId = new QueryCriteria("memId", CriteriaType.STRING,params.get("memId")); //escSingleQuote(piMemId, true);
        QueryCriteria deptCode = new QueryCriteria("deptCode", CriteriaType.STRING,params.get("deptCode")); //escSingleQuote(piDeptCode, true);
        QueryCriteria grpCode = new QueryCriteria("grpCode", CriteriaType.STRING,params.get("grpCode")); //escSingleQuote(piGrpCode, true);
        QueryCriteria orgCode = new QueryCriteria("orgCode", CriteriaType.STRING,params.get("orgCode")); // escSingleQuote(piOrgCode, true);
        QueryCriteria invoicePoNo = new QueryCriteria("invoicePoNo", CriteriaType.STRING,params.get("invoicePoNo")); // escSingleQuote(piInvoicePoNo, true);
        QueryCriteria isEKeyin = new QueryCriteria("isEKeyin", CriteriaType.STRING,params.get("isEKeyin")); // escSingleQuote(piIsEKeyin, false);
        QueryCriteria isECommerce = new QueryCriteria("isECommerce", CriteriaType.STRING,params.get("isECommerce"));  //escSingleQuote(piIsECommerce, false);
        QueryCriteria isSelectAll = new QueryCriteria("isSelectAll", CriteriaType.STRING,params.get("isSelectAll")); //escSingleQuote(piIsSelectAll, false);
        QueryCriteria memID = new QueryCriteria("memID", CriteriaType.OTHER,params.get("memID")); //escSingleQuote(piMemID, true);
        QueryCriteria arrAppType = new QueryCriteria("arrAppType", CriteriaType.OTHER,params.get("arrAppType")); //transformStrArrayToInClauseValues(piArrAppType);
        QueryCriteria arrOrdStusId = new QueryCriteria("arrOrdStusId", CriteriaType.STRING,params.get("arrOrdStusId")); //transformStrArrayToInClauseValues(piArrOrdStusId);
        QueryCriteria billGroupNo = new QueryCriteria("billGroupNo", CriteriaType.STRING,params.get("billGroupNo")); //escSingleQuote(piBillGroupNo, true);
        QueryCriteria arrKeyinBrnchId = new QueryCriteria("arrKeyinBrnchId", CriteriaType.STRING,params.get("arrKeyinBrnchId")); //transformStrArrayToInClauseValues(piArrKeyinBrnchId);
        QueryCriteria arrDscBrnchId = new QueryCriteria("arrDscBrnchId", CriteriaType.STRING,params.get("arrDscBrnchId")); //transformStrArrayToInClauseValues(piArrDscBrnchId);
        QueryCriteria custId = new QueryCriteria("custId", CriteriaType.OTHER,params.get("custId")); //escSingleQuote(piCustId, true);
        QueryCriteria productId = new QueryCriteria("productId", CriteriaType.OTHER,params.get("productId")); //escSingleQuote(piProductId, true);
        QueryCriteria arrRentStus = new QueryCriteria("arrRentStus", CriteriaType.STRING,params.get("arrRentStus")); //transformStrArrayToInClauseValues(piArrRentStus);
        QueryCriteria refNo = new QueryCriteria("refNo", CriteriaType.STRING,params.get("refNo")); //escSingleQuote(piRefNo, true);
        QueryCriteria poNo = new QueryCriteria("poNo", CriteriaType.STRING,params.get("poNo")); //escSingleQuote(piPoNo, true);
        QueryCriteria promoCode = new QueryCriteria("promoCode", CriteriaType.STRING,params.get("promoCode")); //escSingleQuote(piPromoCode, true);
        QueryCriteria relatedNo = new QueryCriteria("relatedNo", CriteriaType.STRING,params.get("relatedNo")); //escSingleQuote(piRelatedNo, true);
        QueryCriteria arrayCustId = new QueryCriteria("arrayCustId", CriteriaType.STRING,params.get("arrayCustId")); //transformStrArrayToInClauseValues(piArrayCustId);

        StringBuilder sbSql = new StringBuilder();

        sbSql.append("SELECT T.APP_TYPE_CODE ");
        sbSql.append(", T.APP_TYPE_NAME ");
        sbSql.append(", T.CRT_USER_ID ");
        sbSql.append(", T.CUST_IC ");
        sbSql.append(", T.CUST_NAME ");
        sbSql.append(", T.CUST_VA_NO ");
        sbSql.append(", T.DSC_BRNCH_ID ");
        sbSql.append(", T.KEYIN_BRNCH_ID ");
        sbSql.append(", T.ORD_ID ");
        sbSql.append(", T.ORD_NO ");
        sbSql.append(", T.ORD_STUS_CODE ");
        sbSql.append(", T.PO_NO ");
        sbSql.append(", T.PRODUCT_CODE ");
        sbSql.append(", T.PRODUCT_NAME ");
        sbSql.append(", T.REF_NO ");
        sbSql.append(", T.RENT_STUS ");
        sbSql.append(", T.SALESMAN_MEM_ID ");
        sbSql.append(", T.SALESMAN_CODE ");
        sbSql.append(", T.SALESMAN_MEM_TYPE_ID ");
        sbSql.append(", T.BILLING_GRP_ID ");
        sbSql.append(", T.MAIL_TEL_MOB ");
        sbSql.append(", T.MAIL_TEL_FAX ");
        sbSql.append(", T.MAIL_TEL_OFF ");
        sbSql.append(", T.MAIL_TEL_RES ");
        sbSql.append(", T.INST_TEL_FAX ");
        sbSql.append(", T.INST_TEL_MOB ");
        sbSql.append(", T.INST_TEL_OFF ");
        sbSql.append(", T.INST_TEL_RES ");
        sbSql.append(", T.SIRIM_NO ");
        sbSql.append(", T.SERIAL_NO ");
        sbSql.append(", T.PROMO_CODE ");
        sbSql.append(", T.PROMO_DESC ");
        sbSql.append(", T.RELATED_NO ");
        sbSql.append(", T.RELATED_ID ");
        sbSql.append(", 1 C1 ");
        sbSql.append(", COALESCE(T.APP_TYPE_ID, 0) AS APP_TYPE_ID ");
        sbSql.append(", COALESCE(T.CUST_ID, 0) AS CUST_ID ");
        sbSql.append(", T.ORD_DT AS ORD_DT ");
        sbSql.append(", COALESCE(T.ORD_STUS_ID, 0) AS ORD_STUS_ID ");
        sbSql.append(", COALESCE(T.PRODUCT_ID, 0) AS PRODUCT_ID ");
        sbSql.append(", T.PV_MONTH ");
        sbSql.append(", T.PV_YEAR ");
        sbSql.append(", T.BNDL_ID ");
        sbSql.append(", T.ECOMM_ORD_ID ");
        sbSql.append(", T.STK_CTGRY_ID ");
        sbSql.append("FROM ( SELECT ");
        sbSql.append("  V1.APP_TYPE_CODE ");
        sbSql.append(", V1.APP_TYPE_ID ");
        sbSql.append(", V1.APP_TYPE_NAME ");
        sbSql.append(", V1.CRT_USER_ID ");
        sbSql.append(", V1.CUST_IC ");
        sbSql.append(", V1.CUST_NAME ");
        sbSql.append(", V1.CUST_ID ");
        sbSql.append(", V1.CUST_VA_NO ");
        sbSql.append(", V1.DSC_BRNCH_ID ");
        sbSql.append(", V1.KEYIN_BRNCH_ID ");
        sbSql.append(", V1.ORD_DT ");
        sbSql.append(", V1.ORD_ID ");
        sbSql.append(", V1.ORD_NO ");
        sbSql.append(", V1.ORD_STUS_CODE ");
        sbSql.append(", V1.ORD_STUS_ID ");
        sbSql.append(", V1.PO_NO ");
        sbSql.append(", V1.PRODUCT_ID ");
        sbSql.append(", V1.PRODUCT_CODE ");
        sbSql.append(", V1.PRODUCT_NAME ");
        sbSql.append(", V1.REF_NO ");
        sbSql.append(", V1.RENT_STUS ");
        sbSql.append(", V1.SALESMAN_MEM_ID ");
        sbSql.append(", V1.SALESMAN_CODE ");
        sbSql.append(", V1.SALESMAN_MEM_TYPE_ID ");
        sbSql.append(", V1.BILLING_GRP_ID ");
        sbSql.append(", V1.MAIL_TEL_MOB ");
        sbSql.append(", V1.MAIL_TEL_FAX ");
        sbSql.append(", V1.MAIL_TEL_OFF ");
        sbSql.append(", V1.MAIL_TEL_RES ");
        sbSql.append(", V1.INST_TEL_FAX ");
        sbSql.append(", V1.INST_TEL_MOB ");
        sbSql.append(", V1.INST_TEL_OFF ");
        sbSql.append(", V1.INST_TEL_RES ");
        sbSql.append(", V1.SIRIM_NO ");
        sbSql.append(", V1.SERIAL_NO ");
        sbSql.append(", V1.ITM_PRC_ID ");
        sbSql.append(", V1.PV_MONTH ");
        sbSql.append(", V1.PV_YEAR ");
        sbSql.append(", V1.PROMO_CODE ");
        sbSql.append(", V1.PROMO_DESC ");
        sbSql.append(", V1.RELATED_NO ");
        sbSql.append(", V1.RELATED_ID ");
        sbSql.append(", V1.BNDL_ID ");
        sbSql.append(", V1.ECOMM_ORD_ID ");
        sbSql.append(", V1.STK_CTGRY_ID ");
        sbSql.append(", V1.EKEY_IN_ID ");
        sbSql.append("FROM OrderMgmtT V1 ");

/*

        String sql = "SELECT T.APP_TYPE_CODE\n" +
                "         , T.APP_TYPE_NAME\n" +
                "         , T.CRT_USER_ID\n" +
                "         , T.CUST_IC\n" +
                "         , T.CUST_NAME\n" +
                "         , T.CUST_VA_NO\n" +
                "         , T.DSC_BRNCH_ID\n" +
                "         , T.KEYIN_BRNCH_ID\n" +
                "         , T.ORD_ID\n" +
                "         , T.ORD_NO\n" +
                "         , T.ORD_STUS_CODE\n" +
                "         , T.PO_NO\n" +
                "         , T.PRODUCT_CODE\n" +
                "         , T.PRODUCT_NAME\n" +
                "         , T.REF_NO\n" +
                "         , T.RENT_STUS\n" +
                "         , T.SALESMAN_MEM_ID\n" +
                "         , T.SALESMAN_CODE\n" +
                "         , T.SALESMAN_MEM_TYPE_ID\n" +
                "         , T.BILLING_GRP_ID\n" +
                "         , T.MAIL_TEL_MOB\n" +
                "         , T.MAIL_TEL_FAX\n" +
                "         , T.MAIL_TEL_OFF\n" +
                "         , T.MAIL_TEL_RES\n" +
                "         , T.INST_TEL_FAX\n" +
                "         , T.INST_TEL_MOB\n" +
                "         , T.INST_TEL_OFF\n" +
                "         , T.INST_TEL_RES\n" +
                "         , T.SIRIM_NO\n" +
                "         , T.SERIAL_NO\n" +
                "         , T.PROMO_CODE\n" +
                "         , T.PROMO_DESC\n" +
                "         , T.RELATED_NO\n" +
                "         , T.RELATED_ID\n" +
                "         , 1 C1\n" +
                "         , COALESCE(T.APP_TYPE_ID, 0) AS APP_TYPE_ID\n" +
                "         , COALESCE(T.CUST_ID, 0) AS CUST_ID\n" +
                "         , T.ORD_DT AS ORD_DT\n" +
                "         , COALESCE(T.ORD_STUS_ID, 0) AS ORD_STUS_ID\n" +
                "         , COALESCE(T.PRODUCT_ID, 0) AS PRODUCT_ID\n" +
                "         , T.PV_MONTH\n" +
                "         , T.PV_YEAR\n" +
                "         , T.BNDL_ID\n" +
                "         , T.ECOMM_ORD_ID\n" +
                "         , T.STK_CTGRY_ID\n" +
                "    FROM ( SELECT\n" +
                "                  V1.APP_TYPE_CODE\n" +
                "                , V1.APP_TYPE_ID\n" +
                "                , V1.APP_TYPE_NAME\n" +
                "                , V1.CRT_USER_ID\n" +
                "                , V1.CUST_IC\n" +
                "                , V1.CUST_NAME\n" +
                "                , V1.CUST_ID\n" +
                "                , V1.CUST_VA_NO\n" +
                "                , V1.DSC_BRNCH_ID\n" +
                "                , V1.KEYIN_BRNCH_ID\n" +
                "                , V1.ORD_DT\n" +
                "                , V1.ORD_ID\n" +
                "                , V1.ORD_NO\n" +
                "                , V1.ORD_STUS_CODE\n" +
                "                , V1.ORD_STUS_ID\n" +
                "                , V1.PO_NO\n" +
                "                , V1.PRODUCT_ID\n" +
                "                , V1.PRODUCT_CODE\n" +
                "                , V1.PRODUCT_NAME\n" +
                "                , V1.REF_NO\n" +
                "                , V1.RENT_STUS\n" +
                "                , V1.SALESMAN_MEM_ID\n" +
                "                , V1.SALESMAN_CODE\n" +
                "                , V1.SALESMAN_MEM_TYPE_ID\n" +
                "                , V1.BILLING_GRP_ID\n" +
                "                , V1.MAIL_TEL_MOB\n" +
                "                , V1.MAIL_TEL_FAX\n" +
                "                , V1.MAIL_TEL_OFF\n" +
                "                , V1.MAIL_TEL_RES\n" +
                "                , V1.INST_TEL_FAX\n" +
                "                , V1.INST_TEL_MOB\n" +
                "                , V1.INST_TEL_OFF\n" +
                "                , V1.INST_TEL_RES\n" +
                "                , V1.SIRIM_NO\n" +
                "                , V1.SERIAL_NO\n" +
                "                , V1.ITM_PRC_ID\n" +
                "                , V1.PV_MONTH\n" +
                "                , V1.PV_YEAR\n" +
                "                , V1.PROMO_CODE\n" +
                "                , V1.PROMO_DESC\n" +
                "                , V1.RELATED_NO\n" +
                "                , V1.RELATED_ID\n" +
                "                , V1.BNDL_ID\n" +
                "                , V1.ECOMM_ORD_ID\n" +
                "                , V1.STK_CTGRY_ID\n" +
                "                , V1.EKEY_IN_ID\n" +
                "         FROM OrderMgmtT V1";*/

        if (!memType.isNullOrEmpty() ) {
           /* sql += " JOIN (\n" +
                    "                    SELECT DISTINCT CUST_ID, SALES_ORD_ID\n" +
                    "                    FROM OrderMgmtFirstChoose WHERE 1 = 1";*/
            sbSql.append("JOIN ( ");
            sbSql.append("SELECT DISTINCT CUST_ID, SALES_ORD_ID ");
            sbSql.append("FROM OrderMgmtFirstChoose WHERE 1 = 1 ");

            if (!ordId.isNullOrEmpty()) {
//                sql += " AND SALES_ORD_ID" + ordId.eq();
                sbSql.append("AND SALES_ORD_ID " + ordId.eq());
            }
            if (!ordNo.isNullOrEmpty()) {
//                sql += " AND SALES_ORD_NO" + ordNo.eq();
                sbSql.append("AND SALES_ORD_NO " + ordNo.eq());
            }
            if (!ordDt.isNullOrEmpty()) {
//                sql += " AND SALES_DT" + ordDt.between();
                sbSql.append("AND SALES_DT " + ordDt.between());
            }
            else {
//                sql += " AND SALES_DT" + ordStartDt.between();
                sbSql.append("AND SALES_DT " + ordStartDt.between());
            }

            if (!memId.isNullOrEmpty()) {
//                sql += " AND (MEM_ID" + memId.eq() + " OR TYPE_ID = 965)";
                sbSql.append("AND (MEM_ID" + memId.eq() + " OR TYPE_ID = 965) ");
            }
            if (!deptCode.isNullOrEmpty()) {
//                sql += " AND (DEPT_CODE" + deptCode.eq() + " OR TYPE_ID = 965)";
                sbSql.append("AND (DEPT_CODE" + deptCode.eq() + " OR TYPE_ID = 965) ");
            }
            if (!grpCode.isNullOrEmpty()) {
//                sql += " AND (GRP_CODE" + deptCode.eq() + " OR TYPE_ID = 965)";
                sbSql.append("AND (GRP_CODE" + deptCode.eq() + " OR TYPE_ID = 965) ");
            }
            if (!orgCode.isNullOrEmpty()) {
//                sql += " AND (ORG_CODE" + orgCode.eq() + " OR TYPE_ID = 965)";
                sbSql.append("AND (ORG_CODE" + orgCode.eq() + " OR TYPE_ID = 965) ");
            }

//            sql += ") SVC ON V1.ORD_ID = SVC.SALES_ORD_ID";
            sbSql.append(") SVC ON V1.ORD_ID = SVC.SALES_ORD_ID ");
        }
        else {
            /*sql += " JOIN (\n" +
                    "                    SELECT DISTINCT CUST_ID, SALES_ORD_ID\n" +
                    "                    FROM OrderMgmtSecondChoose WHERE 1 = 1";*/

            sbSql.append(" JOIN ( ");
            sbSql.append("SELECT DISTINCT CUST_ID, SALES_ORD_ID ");
            sbSql.append("FROM OrderMgmtSecondChoose WHERE 1 = 1 ");

            if (!memId.isNullOrEmpty()) {
//                sql += " AND (MEM_ID" + memId.eq() + ")";
                sbSql.append("AND (MEM_ID" + memId.eq() + ") ");
            }
            if (!deptCode.isNullOrEmpty()) {
//                sql += " AND (DEPT_CODE" + deptCode.eq() + ")";
                sbSql.append("AND (DEPT_CODE" + deptCode.eq() + ") ");
            }
            if (!grpCode.isNullOrEmpty()) {
//                sql += " AND (GRP_CODE" + deptCode.eq() + ")";
                sbSql.append("AND (GRP_CODE" + deptCode.eq() + ") ");
            }
//            sql += ") SVC ON V1.ORD_ID = SVC.SALES_ORD_ID";
            sbSql.append(") SVC ON V1.ORD_ID = SVC.SALES_ORD_ID");
        }

//        sql += " WHERE 1 = 1";
        sbSql.append(" WHERE 1 = 1");

        if (!ordDt.isNullOrEmpty()) {
//            sql += " AND V1.SALES_DT" + ordDt.between();
            sbSql.append(" AND V1.SALES_DT" + ordDt.between());
        }
        else {
//            sql += " AND V1.SALES_DT" + ordStartDt.between();
            sbSql.append(" AND V1.SALES_DT" + ordStartDt.between());
        }

        if (!invoicePoNo.isNullOrEmpty()) {
//            sql += " AND V1.ORD_ID IN (SELECT DISTINCT PO_ORD_ID FROM OrderMgmtPay0015d WHERE PO_REF_NO" + invoicePoNo.eq() + ")";
            sbSql.append(" AND V1.ORD_ID IN (SELECT DISTINCT PO_ORD_ID FROM OrderMgmtPay0015d WHERE PO_REF_NO" + invoicePoNo.eq() + ")");
        }
        if (!isEKeyin.isNullOrEmpty()) {
//            sql += " AND V1.EKEY_IN_ID IS NOT NULL";
            sbSql.append(" AND V1.EKEY_IN_ID IS NOT NULL");
        }
        if (!isECommerce.isNullOrEmpty()) {
//            sql += " AND ECOMM_ORD_ID > 0";
            sbSql.append(" AND ECOMM_ORD_ID > 0");
        }
        if (isSelectAll.isNullOrEmpty()) {
//            sql += " AND V1.APP_TYPE_ID NOT IN (5764)";
            sbSql.append(" AND V1.APP_TYPE_ID NOT IN (5764)");
        }
        if (!memID.isNullOrEmpty()) {
//            sql += " AND V1.SALESMAN_MEM_ID" + memID.eq();
            sbSql.append(" AND V1.SALESMAN_MEM_ID" + memID.eq());
        }
        if (!arrAppType.isNullOrEmpty()) {
//            sql += " AND V1.APP_TYPE_ID" + arrAppType.in();
            sbSql.append(" AND V1.APP_TYPE_ID" + arrAppType.in());
        }
        if (!arrOrdStusId.isNullOrEmpty()) {
//            sql += " AND V1.ORD_STUS_ID" + arrOrdStusId.in();
            sbSql.append(" AND V1.ORD_STUS_ID" + arrOrdStusId.in());
        }
        if (!billGroupNo.isNullOrEmpty()) {
//            sql += " AND V1.BILLING_GRP_ID" + billGroupNo.eq();
            sbSql.append(" AND V1.BILLING_GRP_ID" + billGroupNo.eq());
        }

       /* sql += ") T";
        sql += " WHERE 1 = 1";*/

        sbSql.append(") T");
        sbSql.append(" WHERE 1 = 1");

        if (!ordNo.isNullOrEmpty()) {
//            sql += " AND T.ORD_NO" + ordNo.eq();
            sbSql.append(" AND T.ORD_NO" + ordNo.eq());
        }

        if (!ordId.isNullOrEmpty()) {
//            sql += " AND T.ORD_ID" + ordId.eq();
            sbSql.append(" AND T.ORD_ID" + ordId.eq());
        }

        if (!arrKeyinBrnchId.isNullOrEmpty()) {
//            sql += " AND T.KEYIN_BRNCH_ID" + arrKeyinBrnchId.in();
            sbSql.append(" AND T.KEYIN_BRNCH_ID" + arrKeyinBrnchId.in());
        }

        if (!arrDscBrnchId.isNullOrEmpty()) {
//            sql += " AND T.DSC_BRNCH_ID" + arrDscBrnchId.in();
            sbSql.append(" AND T.DSC_BRNCH_ID" + arrDscBrnchId.in());
        }

        if (!custId.isNullOrEmpty()) {
//            sql += " AND T.CUST_ID" + custId.eq();
            sbSql.append(" AND T.CUST_ID" + custId.eq());
        }

        if (!productId.isNullOrEmpty()) {
//            sql += " AND T.PRODUCT_ID" + productId.eq();
            sbSql.append(" AND T.PRODUCT_ID" + productId.eq());
        }

        if (!arrRentStus.isNullOrEmpty()) {
//            sql += " AND T.RENT_STUS" + arrRentStus.in();
            sbSql.append(" AND T.RENT_STUS" + arrRentStus.in());
        }

        if (!refNo.isNullOrEmpty()) {
//            sql += " AND T.REF_NO" + refNo.eq();
            sbSql.append(" AND T.REF_NO" + refNo.eq());
        }

        if (!poNo.isNullOrEmpty()) {
//            sql += " AND T.PO_NO" + poNo.eq();
            sbSql.append(" AND T.PO_NO" + poNo.eq());
        }

        if (!promoCode.isNullOrEmpty()) {
//            sql += " AND T.PROMO_CODE" + promoCode.eq();
            sbSql.append(" AND T.PROMO_CODE" + promoCode.eq());
        }

        if (!relatedNo.isNullOrEmpty()) {
//            sql += " AND T.RELATED_NO" + relatedNo.eq();
            sbSql.append(" AND T.RELATED_NO" + relatedNo.eq());
        }

        if (!arrayCustId.isNullOrEmpty()) {
//            sql += " AND T.CUST_ID" + arrayCustId.in();
            sbSql.append(" AND T.CUST_ID" + arrayCustId.in());
        }

//        logger.debug("Generated sbSql: " + sbSql);
//        return sql;
        return sbSql.toString();
    }

    public OrderMgmt(String[] hzServers) {
        super(hzServers);
    }



    public static void debugPassInParams(Map<String, Object> params) {
      Set<String> paramKeys = params.keySet();
      for (String paramKey : paramKeys) {
        boolean isList = params.get(paramKey) instanceof List;
        if (isList) {
          logger.info("Param key: " + paramKey + ", isList: true");
        }
        else {
          try {
            String[] strArr = (String[]) params.get(paramKey);

            logger.info("KKKKKKKKKKK " + strArr[0]);
          }
          catch (Exception ex) {
          }
          logger.info("Param key: " + paramKey + ", isList: false, value: " + params.get(paramKey).toString());
        }
      }
    }

    public static List<EgovMap> transformToEgovMapList(List<Map<String,Object>> resultSet) {
      List<EgovMap> retResult = new ArrayList<>();
        for (Map<String,Object> rec : resultSet) {
          EgovMap retRec = new EgovMap();
          Set<String> keys = rec.keySet();
          for (String key : keys) {
            retRec.put(key, rec.get(key));
          }
          retResult.add(retRec);
        }
      return retResult;
    }

//    public static void main(String args[]) {
//        OrderMgmt orderMgmt = new OrderMgmt(new String[] {"10.201.32.149:5701","10.201.32.187:5701","10.201.32.205:5701"});
//
//        Map<String,Object> params = new HashMap<>();
//        params.put("ordStartDt","2021-01-01");
//        params.put("ordEndDt","2022-12-31");
//
//        String sql = orderMgmt.buildSql(
//                params
//        );
//        logger.debug("Generated sql: " + sql);
//        List<Map<String,Object>> resultSet = orderMgmt.query(sql);
//
//        logger.debug("Start resultSet Size: " + resultSet.size());
//        int recIdx = 0;
//        for (Map<String,Object> rec : resultSet) {
//            logger.debug("Record " + (++recIdx) + ". order no." + rec.get("ORD_NO"));
//        }
//        logger.debug("End resultSet Size: " + resultSet.size());
//    }





//  public String buildSql(String piMemType,
//  String piOrdId,
//  String piOrdNo,
//  String piOrdDt,
//  String piOrdStartDt,
//  String piOrdEndDt,
//  String piMemId,
//  String piDeptCode,
//  String piGrpCode,
//  String piOrgCode,
//  String piInvoicePoNo,
//  String piIsEKeyin,
//  String piIsECommerce,
//  String piIsSelectAll,
//  String piMemID,
//  List<String> piArrAppType,
//  List<String> piArrOrdStusId,
//  String piBillGroupNo,
//  List<String> piArrKeyinBrnchId,
//  List<String> piArrDscBrnchId,
//  String piCustId,
//  String piProductId,
//  List<String> piArrRentStus,
//  String piRefNo,
//  String piPoNo,
//  String piPromoCode,
//  String piRelatedNo,
//  List<String> piArrayCustId
//  ) {
}

