<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<script type="text/javaScript">

    $(function () {

    });

</script>

<div class="nav_wrap">
    <div class="nav_container">
        <h2><span class="title">Title</span><a href="#" class="btn-close"><img
                src="${pageContext.request.contextPath}/resources/mobile/images/btn_clear.gif" alt="닫기"></a></h2>
        <aside class="lnb_wrap"><!-- lnb_wrap start -->
            <section class="lnb_con"><!-- lnb_con start -->
                <ul class="inb_menu ">
                    <li class="active">
                        <a href="/logistics/SerialMgmt/serialMgmtMain.do" class="on">S/N Management</a>

                        <ul>
                            <li class="active">
                                <a href="#" class="on">menu 2depth</a>

                                <ul>
                                    <li class="active">
                                        <a href="#" class="on"> 3depth</a>

                                        <ul>
                                            <li class="active">
                                                <a href="/logistics/SerialMgmt/serialScanGRCDC.do" class="on status_new">GRCDC</a>
                                            </li>
                                            <li>
                                                <a href="/logistics/SerialMgmt/serialScanGICDC.do" class="status_dev">GICDC</a>
                                            </li>
                                            <li>
                                                <a href="/logistics/SerialMgmt/serialScanGIRDC.do" class="status_upd">GIRDC</a>
                                            </li>
                                            <li>
                                                <a href="#" class="disabled">menu 4depth</a>
                                            </li>
                                            <li>
                                                <a href="#">menu 4depth</a>
                                            </li>
                                            <li>
                                                <a href="#">menu 4depth</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="#" class="status_new">menu 3depth</a>
                                    </li>
                                    <li>
                                        <a href="#">menu 3depth</a>
                                    </li>
                                    <li>
                                        <a href="#">menu 3depth</a>
                                    </li>
                                    <li>
                                        <a href="#">menu 3depth</a>
                                    </li>
                                    <li>
                                        <a href="#">menu 3depth</a>
                                    </li>
                                </ul>

                            </li>
                            <li>
                                <a href="#">menu 2depth</a>
                            </li>
                            <li>
                                <a href="#">menu 2depth</a>
                            </li>
                            <li>
                                <a href="#">menu 2depth</a>
                            </li>
                            <li>
                                <a href="#">menu 2depth</a>
                            </li>
                            <li>
                                <a href="#">menu 2depth</a>
                            </li>
                        </ul>

                    </li>
                    <li>
                        <a href="#">menu 1depth</a>
                    </li>
                    <li>
                        <a href="#">menu 1depth</a>
                    </li>
                    <li>
                        <a href="#">menu 1depth</a>
                    </li>
                    <li>
                        <a href="#">menu 1depth</a>
                    </li>
                    <li>
                        <a href="#">menu 1depth</a>
                    </li>
                </ul>
            </section><!-- lnb_con end -->
        </aside><!-- lnb_wrap end -->
    </div>
</div>
