<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


    <script type="text/javaScript" language="javascript">
        var gradioVal = $("input:radio[name='searchDivCd']:checked").val();

        var myGridID;
        var gridValue;


        var option = {
                width : "1000px", // 창 가로 크기
                height : "600px" // 창 세로 크기
            };

        function fn_close(){
            window.close();
        }
        
        
       var columnLayoutRejoin = [ {
                            dataField:"lastOrgCode",
                            headerText:"GM",
                            width:120,
                            height:30
                        }, {
                            dataField : "lastGrpCode",
                            headerText : "SCM",
                            width : 120
                        }, {
                            dataField : "lastDeptCode",
                            headerText : "CM",
                            width : 120
                        }, {
                            dataField : "rejoinTargetPercent",
                            headerText : "REJOIN TARGET %",
                            width : 120
                        }, {
                            dataField : "totalExpired",
                            headerText : "EXPIRED",
                            width : 120 
                        }, {
                            dataField : "totalSvm",
                            headerText : "SVM",
                            width : 120
                        }, {
                            dataField : "totalExtrade",
                            headerText : "EXTRADE",
                            width : 120
                        }, {
                            dataField : "totalRejoin",
                            headerText : "TOTAL",
                            width : 120
                        }, {
                            dataField : "totalRejoin",
                            headerText : "REJOIN",
                            width : 120
                        }, {
                            dataField : "rejoinPercent",
                            headerText : "REJOIN %",
                            width : 120 
                     }];
                    

       var columnLayoutCollection = [ {
                            dataField:"lastorgCode",
                            headerText:"GM",
                            width:120,
                            height:30
                        }, {
                            dataField : "lastGrpCode",
                            headerText : "SCM",
                            width : 120
                        }, {
                            dataField : "lastDeptCode",
                            headerText : "CM",
                            width : 120
                        }, {
                            dataField : "collectionTargetPercent",
                            headerText : "COLLECTION TARGET %",
                            width : 120
                        }, {
                            dataField : "noOfAcct",
                            headerText : "NO OF ACCT",
                            width : 120 
                        }, {
                            dataField : "target",
                            headerText : "TARGET",
                            width : 120
                        }, {
                            dataField : "collection",
                            headerText : "COLLECTION",
                            width : 120
                        }, {
                            dataField : "collectionPercent",
                            headerText : "COLLECTION%",
                            width : 120
                        }, {
                            dataField : "code",
                            headerText : "REJOIN",
                            width : 120
                        }, {
                            dataField : "addPercent",
                            headerText : "ADD%",
                            width : 120 
                     }];
                     
                     
                    
                    
                    
       var columnLayoutHeartService = [ {
                            dataField:"scm",
                            headerText:"GM",
                            width:120,
                            height:30
                        }, {
                            dataField : "cm",
                            headerText : "SCM",
                            width : 120
                        }, {
                            dataField : "cody",
                            headerText : "CM",
                            width : 120
                        }, {
                            dataField : "",
                            headerText : "HEART SERVICE TARGET %",
                            width : 120
                        }, {
                            dataField : "noOfAcct",
                            headerText : "NO OF ACCT",
                            width : 120 
                        }, {
                            dataField : "complete",
                            headerText : "COMPLETE",
                            width : 120
                        }, {
                            dataField : "fail",
                            headerText : "FAIL",
                            width : 120
                        }, {
                            dataField : "cancel",
                            headerText : "CANCEL",
                            width : 120
                        }, {
                            dataField : "completePercent",
                            headerText : "COMPLETE%",
                            width : 120
                     }];
                     
                     
                     
                     
                     
       var columnLayoutSales = [ {
                            dataField:"scm",
                            headerText:"GM",
                            width:120,
                            height:30
                        }, {
                            dataField : "cm",
                            headerText : "SCM",
                            width : 120
                        }, {
                            dataField : "cody",
                            headerText : "CM",
                            width : 120
                        }, {
                            dataField : "salesTarget",
                            headerText : "SALES TARGET",
                            width : 120
                        }, {
                            dataField : "KeyIn",
                            headerText : "KEY IN",
                            width : 120 
                        }, {
                            dataField : "ys",
                            headerText : "YS",
                            width : 120
                        }, {
                            dataField : "netSales",
                            headerText : "NET SALES",
                            width : 120
                        }, {
                            dataField : "extrade",
                            headerText : "EXTRADE",
                            width : 120
                        }, {
                            dataField : "salesPercent",
                            headerText : "SALES %",
                            width : 120
                     }];


            var gridPros = {
          // 페이징 사용
             usePaging : true,
             pageRowCount : 20,
             editable :  false
             };
                                  
                     
                                          
                                                              
                            
        

        $(document).ready(function() {
           $('#myBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
           
           $("#cmdBranchCode").change(function() {
	            $("#cmdCdManager").find('option').each(function() {
	                $(this).remove();
	            });
	
	            if ($(this).val().trim() == "") {
	                return;
	            }
	            doGetCombo('/services/bs/getCdUpMemList.do', $(this).val() , ''   , 'cmdCdManager' , 'S', '');
	        });
	        
	        fn_checkRadioButton();
	        
	        
	        
        });



        function fn_destroyGridRejoin() {
            myGridID = null;

            AUIGrid.setProp(myGridID, gridPros );
            AUIGrid.destroy("#grid_wrap");
            createAUIGridRejoin(columnLayoutRejoin);
        }
        
        // AUIGrid 를 생성합니다.
        function createAUIGridRejoin(columnLayoutRejoin) {
          // 그리드 속성 설정
            // 실제로 #grid_wrap 에 그리드 생성
              myGridID = AUIGrid.create("#grid_wrap", columnLayoutRejoin, gridPros);
        }
                
                
        function fn_destroyGridCollection() {
            myGridID = null;

            AUIGrid.setProp(myGridID, gridPros );
            AUIGrid.destroy("#grid_wrap");
            createAUIGridCollection(columnLayoutCollection);
        }
        
        // AUIGrid 를 생성합니다.
        function createAUIGridCollection(columnLayoutCollection) {
          // 그리드 속성 설정
            // 실제로 #grid_wrap 에 그리드 생성
              myGridID = AUIGrid.create("#grid_wrap", columnLayoutCollection, gridPros);
        }              
        
        

        function fn_destroyGridHeartService() {
            myGridID = null;

            AUIGrid.setProp(myGridID, gridPros );
            AUIGrid.destroy("#grid_wrap");
            createAUIGridService(columnLayoutHeartService);
        }
        
        // AUIGrid 를 생성합니다.
        function createAUIGridHeartService(columnLayoutHeartService) {
          // 그리드 속성 설정
            // 실제로 #grid_wrap 에 그리드 생성
              myGridID = AUIGrid.create("#grid_wrap", columnLayoutHeartService, gridPros);
        } 
        
        
        

        function fn_destroyGridService() {
            myGridID = null;

            AUIGrid.setProp(myGridID, gridPros );
            AUIGrid.destroy("#grid_wrap");
            createAUIGridService(columnLayoutSales);
        }
        
        // AUIGrid 를 생성합니다.
        function createAUIGridService(columnLayoutSales) {
          // 그리드 속성 설정
            // 실제로 #grid_wrap 에 그리드 생성
              myGridID = AUIGrid.create("#grid_wrap", columnLayoutSales, gridPros);
        } 
        
        
                
                
          
        
        function fn_checkRadioButton(objName){
            if( document.searchForm.elements['searchDivCd'][0].checked == true ) {
                 fn_destroyGridRejoin();
            }else if(document.searchForm.elements['searchDivCd'][1].checked == true) {
                 fn_destroyGridCollection();
            }else if(document.searchForm.elements['searchDivCd'][2].checked == true) {
                 fn_destroyGridHeartService();
            }else if(document.searchForm.elements['searchDivCd'][3].checked == true) {
                 fn_destroyGridService();
            }
        }



        function fn_getBSListAjax() {
                var radioVal = $("input:radio[name='searchDivCd']:checked").val();

                if (radioVal == 1 ){ 
                        Common.ajax("GET", "/services/performanceMgmt/selectPfReportRejoin.do", $("#searchForm").serialize(), function(result) {
                            console.log("성공.");
                            console.log("data : " + result);
                            AUIGrid.setGridData(myGridID, result);
                         });
                }else if(radioVal == 2 ) {//hs_no  Create after
                        Common.ajax("GET", "/services/performanceMgmt/selectPfReportCollection.do", $("#searchForm").serialize(), function(result) {
                            console.log("성공.");
                            console.log("data : " + result);
                            AUIGrid.setGridData(myGridID, result);
                        });
                }else if(radioVal == 3 ) {//hs_no  Create after
                        Common.ajax("GET", "/services/performanceMgmt/selectPfReportHeartService.do", $("#searchForm").serialize(), function(result) {
                            console.log("성공.");
                            console.log("data : " + result);
                            AUIGrid.setGridData(myGridID, result);
                        });
                }else if(radioVal == 4 ) {//hs_no  Create after
                        Common.ajax("GET", "/services/performanceMgmt/selectPfReportSales.do", $("#searchForm").serialize(), function(result) {
                            console.log("성공.");
                            console.log("data : " + result);
                            AUIGrid.setGridData(myGridID, result);
                        });
                }

          }

        



    </script>




<form id="popEditForm" method="post">

</form>

<form id="searchForm" name="searchForm">


<section id="content"><!-- content start -->
<ul class="path">
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Cody Performance Report </h2>
<ul class="right_btns">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getBSListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
<!--조회조건 추가  -->

</aside><!-- title_line end -->


<div id="hsManagement" style="display:block;">
<form  id="hsManagement" method="post">

            <section class="search_table"><!-- search_table start -->
            <form action="#" method="post">

            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:100px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">Branch</th>
                <td>
                <select id="cmdBranchCode" name="cmdBranchCode" class="w100p">
                       <option value="">Choose One</option>
                       <c:forEach var="list" items="${branchList }" varStatus="status">
                       <option value="${list.codeId}">${list.codeName}</option>
                       </c:forEach>
                </select>
                </td>
                <th scope="row">Cody Manager</th>
                <td>
                    <select id="cmdCdManager" name="cmdCdManager" class="w100p">
                </td>
                    <th scope="row"> Member Code</th>
                <td>
                   <input id="txtAssigncodyCode" name="txtAssigncodyCode"  type="text" title="" placeholder="Cody" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row" >HS Period</th>
                <td colspan="1">
                    <input id="myBSMonth" name="myBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                </td>
                <th scope="row" ></th>
                <td>
                </td>      
                <td>
                </td>      
                <td>
                </td>      
            </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
				    </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
            </aside><!-- link_btns_wrap end -->

            </form>
            </section><!-- search_table end -->
</form>
</div>
                <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />Rejoin</label>
                <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Collection</label>
                <label><input type="radio" name="searchDivCd" value="3" onClick="fn_checkRadioButton('comm_stat_flag')" />Heart Service</label>
                <label><input type="radio" name="searchDivCd" value="4" onClick="fn_checkRadioButton('comm_stat_flag')" />Sales</label><br><br>

    <ul class="right_btns">


    </ul>

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a id="hSConfiguration">HS Order Create</a></p></li>
</ul> -->
<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getHSConfAjax();">HS Configuration</a></p></li>
</ul> -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width: 100%; height: 400px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
<!--     <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
</ul>

</section><!-- content end -->
</form>
 