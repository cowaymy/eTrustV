<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


      
    // Make AUIGrid 
    var myGridID;

    //Start AUIGrid
    $(document).ready(function() {
        
        // AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"");

        AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
        
        //Rule Book Item search
        $("#search").click(function(){  
            var searchDt = $("#searchDt").val();

            Common.ajax("GET", "/eAccounting/budget/selectBudgetSysMaintenanceList", $("#listSForm").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID, result);
            });
       });
        
        //아이템 grid 행 추가
        $("#addRow").click(function() { 
        	   var item = new Object();

        	    Common.ajax("GET", "/eAccounting/budget/selectBudgetMonth", $("#listSForm").serialize(), function(result) {
        	               
        	           console.log("성공.");
        	           console.log(result);
        	       
        	           item.budgetYear = $("#searchDt").val();
        	           month = result + 1;
        	           var month_char = "";
        	           
        	           if(month == 1) {
        	        	   month_char = 'JAN';
        	           } else if(month == 2) {
        	        	   month_char = 'FEB';
        	           } else if(month == 3) {
        	        	   month_char = 'MAR';
        	           } else if(month == 4) {
        	        	   month_char = 'APR';
        	           } else if(month == 5) {
        	        	   month_char = 'MAY';
        	           } else if(month == 6) {
        	        	   month_char = 'JUN';
        	           } else if(month == 7) {
        	        	   month_char = 'JUL';
        	           } else if(month == 8) {
        	        	   month_char = 'AUG';
        	           } else if(month == 9) {
        	        	   month_char = 'SEP';
        	           } else if(month == 10) {
        	        	   month_char = 'OCT';
        	           } else if(month == 11) {
        	        	   month_char = 'NOV';
        	           } else if(month == 12) {
        	        	   month_char = 'DEC';
        	           }
        	           item.budgetMonth = month_char;
        	           
        	           AUIGrid.addRow(myGridID, item, "last");
        	       });
        });
        
      //save
         $("#save").click(function() {
          if (validation()) {
               
        	   Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData);
              
            }
        }); 
      
    });//Ready
    
      function fn_saveGridData(){
            Common.ajax("POST", "/eAccounting/budget/saveBudgetSysMaintGrid.do", GridCommon.getEditData(myGridID), function(result) {
                // 공통 메세지 영역에 메세지 표시.
                Common.setMsg("<spring:message code='sys.msg.success'/>");
                $("#search").trigger("click");
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                } catch (e) {
                    console.log(e);
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);             
            });
        } 


    // 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
    }
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }

    // AUIGrid 칼럼 설정
    var columnLayout = [{
        dataField : "budgetYear",
        headerText : "Year",  
        width : 300
    }, {
        dataField : "budgetMonth",
        headerText : "Month",
        //dataType : "numeric",
        editRenderer : {
            type : "DropDownListRenderer",
            list : ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        },
        width : 300
    }, {
        dataField : "budgetStus",
        headerText : "Status",
        editRenderer : {
            type : "DropDownListRenderer",
            list : ["Y", "N"],
        }
    }];
    /*  validation */
    function validation() {
        var result = true;
        var addList = AUIGrid.getAddedRowItems(myGridID);
        var udtList = AUIGrid.getEditedRowItems(myGridID);
        if (addList.length == 0 && udtList.length == 0) {
          Common.alert("<spring:message code='sys.common.alert.noChange'/>");
          return false;
        }
        if(!validationCom(addList) || !validationCom(udtList)){
            return false;
       }      
        
        return result;
      }  
    
     function validationCom(list){
         var result = true;
         for (var i = 0; i < list.length; i++) {
                var budgetYear = list[i].budgetYear;
                var budgetMonth = list[i].budgetMonth;
                var budgetStus = list[i].budgetStus;
                if (budgetYear == "") {
                  result = false;
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='Year' htmlEscape='false'/>");
                  break;
                } else if (budgetMonth == "") {
                  result = false;
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='Month' htmlEscape='false'/>");
                  break;
                } else if (budgetStus == "") {
                  result = false;
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='Status' htmlEscape='false'/>");
                  break;
                }
         }
         return result;
     }
</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>eAccount</li>
    <li>Budget System Maintenance</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="budget.SysMaintenance" /></h2>

</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="budget.year" /></th>
    <td>
    <input type="text" id="searchDt" name="searchDt" title="" placeholder="" class="fl_left" />
     <p class="btn_blue"><a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></span></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow"><spring:message code="budget.add" /></a></p></li>
</ul>
<section class="search_result"><!-- search_result start -->
    
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save"><spring:message code='sys.btn.save'/></a></p></li>
</ul>
</section><!-- search_result end -->
</section><!-- content end -->