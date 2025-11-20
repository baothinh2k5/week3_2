# =========================
# Stage 1: Build bằng Maven
# =========================
# Sử dụng Maven với JDK 11 (Khớp với pom.xml của bạn)
FROM maven:3.9.6-eclipse-temurin-11 AS build

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# 1. Copy pom.xml trước để cache các thư viện (giúp build nhanh hơn cho lần sau)
COPY pom.xml .
# Tải các dependency về (JSTL, Jakarta EE, v.v.)
RUN mvn dependency:go-offline

# 2. Copy toàn bộ mã nguồn vào
COPY src ./src

# 3. Build ra file .war (Bỏ qua test để tránh lỗi vặt khi deploy)
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Chạy trên Tomcat 10 (Jakarta EE)
# ==========================================
FROM tomcat:10.1-jdk11

# 1. Xóa các ứng dụng mặc định của Tomcat (docs, examples...) để nhẹ và an toàn
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy file WAR từ Stage 1 sang Stage 2
# QUAN TRỌNG: Đổi tên thành 'ROOT.war' để app chạy ngay tại đường dẫn gốc "/"
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. Mở cổng 8080 (Cổng mặc định của Tomcat)
EXPOSE 8080

# 4. Khởi chạy Tomcat
CMD ["catalina.sh", "run"]